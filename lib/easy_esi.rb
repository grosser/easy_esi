class EasyEsi
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  def self.include_for(data)
    %{<esi:include src="#{serialize(data)}"/>}.html_safe
  end

  def self.replace_includes(text)
    text.gsub(%r{<esi:include src="[^"]*"/>}) do |match|
      match =~ /"(.*)"/
      yield unserialize($1)
    end
  end

  def self.unserialize(data)
    YAML.load Base64.decode64(data)
  end

  def self.serialize(data)
    Base64.encode64(data.to_yaml).gsub("\n",'')
  end

  private

  def self.query_to_hash(string)
    string.split('&').map{|kv| kv.split('=')}.inject({}){|hash, kv| hash[kv[0]]=kv[1];hash}
  end
end

class ActionView::Base
  def esi_render data
    if controller.esi_enabled
      EasyEsi.include_for data
    else
      render data
    end
  end
end

# replace cached includes
# cache miss:
#  filter_with_esi -> filter_without_esi -> after_filter -> filter_with_esi
#  do not replace <include> in after filter, but after filter_without_esi
#
# cache hit:
#  filter_with_esi -> filter_without_esi -> filter_with_esi
#  after_filter will not be called, but <include> needs to be replaced
#
class ActionController::Caching::Actions::ActionCacheFilter
  def filter_with_esi(controller, &block)
    controller.instance_variable_set "@do_not_replace_esi", true
    result = filter_without_esi(controller, &block)
    controller.instance_variable_set "@do_not_replace_esi", false

    controller.send(:render_esi) if controller.esi_enabled

    result
  end
  alias_method_chain :filter, :esi
end

class ActionController::Base
  if respond_to?(:class_attribute)
    class_attribute :esi_enabled
  else
    class_inheritable_accessor :esi_enabled
  end

  def self.enable_esi
    self.esi_enabled = true
    after_filter :render_esi
  end

  protected

  def render_esi
    return if @do_not_replace_esi or not (response_body.kind_of?(String) or response_body.kind_of?(Array))

    self.response_body = case
      when response_body.kind_of?(Array)
        response_body.collect { |e| render_and_replace_esi(e) }
      when response_body.kind_of?(String)
        self.response_body = render_and_replace_esi(response_body)
      end
  end

  def render_and_replace_esi text
    EasyEsi.replace_includes(text) do |data|
      data = {:partial => data} if data.kind_of?(String)
      _render_template(data)
    end
  end
end
