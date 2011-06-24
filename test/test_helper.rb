require 'rubygems'
require 'rspec'
require 'active_support/all'
require 'action_pack'
require 'action_controller'
require 'test/unit'
require 'redgreen'
$LOAD_PATH << 'lib'
require 'init'

ActionController::Base.cache_store = :memory_store

if ActionPack::VERSION::MAJOR > 2
  require 'action_dispatch/testing/test_process'

# fake checks
  require 'ostruct'
  module ActionController::UrlFor
    def _routes
      helpers = OpenStruct.new
      helpers.url_helpers = Module.new
      helpers
    end
  end

  ROUTES = ActionDispatch::Routing::RouteSet.new
  ROUTES.draw do
    match ':controller(/:action(/:id(.:format)))'
  end
  ROUTES.finalize!

# funky patch to get @routes working, in 'setup' did not work
  module ActionController::TestCase::Behavior
    def process_with_routes(*args)
      @routes = ROUTES
      process_without_routes(*args)
    end
    alias_method_chain :process, :routes
  end

  class ActionController::Base
    self.view_paths = 'test/views'

    def self._routes
      ROUTES
    end

    def url_for(*args)
      'xxx'
    end
  end
else
  require 'action_controller/test_process'

  ActionController::Routing::Routes.reload rescue nil
  ActionController::Base.cache_store = :memory_store

  class ActionController::Base
    before_filter :set_view_paths

    def set_view_paths
      @template.view_paths = 'test/views'
    end
  end
end
