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

# when action_cache halts the filter chain, we still need to replace esi includes
class ActionController::Caching::Actions::ActionCacheFilter
  def filter_with_esi(controller, &block)
    controller.instance_variable_set "@do_not_replace", true
    result = filter_without_esi(controller, &block)
    controller.instance_variable_set "@do_not_replace", false
    puts controller.response_body+'filter'
    controller.send(:render_esi) if controller.esi_enabled
    result
  end
  alias_method_chain :filter, :esi
end

class ActionController::Base
  class_inheritable_accessor :esi_enabled

  def self.enable_esi
    self.esi_enabled = true
    after_filter :render_esi
  end

  protected

  def render_esi
    return if @do_not_replace or response_body.is_a?(File)
    self.response_body = EasyEsi.replace_includes(response_body) do |data|
      _render_template(data)
    end
  end
end
