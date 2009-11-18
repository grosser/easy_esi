class ActionView::Base
  def esi_render data
    if controller.esi_enabled
      serialized = data.is_a?(Hash) ? data.to_query : data
      %{<esi:include src="#{serialized}"/>}
    else
      render data
    end
  end
end

# when action_cache halts the filter chain, we still need to replace esi includes 
class ActionController::Caching::Actions::ActionCacheFilter
  def before_with_esi(controller)
    result = before_without_esi(controller)
    controller.send(:render_esi) if result == false and controller.esi_enabled
    result
  end
  alias_method_chain :before, :esi
end

class ActionController::Base
  class_inheritable_accessor :esi_enabled

  def self.enable_esi
    self.esi_enabled = true
    after_filter :render_esi
  end

  protected

  def render_esi
    response.body.gsub!(%r{<esi:include src="([^"]*)"/>}) do
      @template.render esi_unserialize($1)
    end
  end

  def esi_unserialize(string)
    if string.include? '=' # its a Hash ...
      string = CGI.unescape(string)
      string.split('&').map{|kv| kv.split('=')}.inject({}){|hash, kv| hash[kv[0]]=kv[1];hash}
    else
      string
    end
  end
end