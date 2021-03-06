require 'rubygems'
require 'rspec'
require 'active_support/all'
require 'action_pack'
require 'action_controller'
require 'test/unit'
$LOAD_PATH << 'lib'
require 'easy_esi'

ActionController::Base.cache_store = :memory_store

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
