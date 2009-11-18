class EasyEsi
  def self.include_for(data)
    serialized = data.is_a?(Hash) ? data.to_query : data
    %{<esi:include src="#{serialized}"/>}
  end

  def self.replace_includes(text)
    text.gsub(%r{<esi:include src="([^"]*)"/>}) do
      yield unserialize_include($1)
    end
  end

  def self.unserialize_include(string)
    string = CGI.unescape(string)
    if string.include? '=' # it was a Hash ...
      query_to_hash(string).with_indifferent_access
    else
      string
    end
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
    response.body = EasyEsi.replace_includes(response.body) do |data|
      @template.render data
    end
  end
end