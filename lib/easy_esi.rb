class EasyEsi
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  
  def self.include_for(data)
    %{<esi:include src="#{serialize(data)}"/>}
  end

  def self.replace_includes(text)
    text.gsub!(%r{<esi:include src="([^"]*)"/>}) do
      yield unserialize($1)
    end
  end

  def self.unserialize(data)
    YAML.load Base64.decode64(data)
  end

  def self.serialize(data)
    Base64.encode64 data.to_yaml
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
#  def filter_with_esi(controller)
#    result = filter_without_esi(controller)
#    controller.send(:render_esi) if controller.esi_enabled
#    result
#  end
#  alias_method_chain :filter, :esi
end

class ActionController::Base
  class_inheritable_accessor :esi_enabled

  def self.enable_esi
    self.esi_enabled = true
    after_filter :render_esi
  end

  protected

  def render_esi
    EasyEsi.replace_includes(controller.response_body) do |data|
      @template.render data
    end
  end
end
