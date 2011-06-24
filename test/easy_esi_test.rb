require 'test/test_helper'

class EsiDisabledController < ActionController::Base
  self.view_paths = 'test/views'
  caches_action :show, :random, :with_hash

  def random
    render :text => rand.to_s
  end

  def show
  end

  def with_hash
  end

  def uncached
    render :action => :show
  end
end

class EsiDisabledTest < ActionController::TestCase
  def setup
    @controller = EsiDisabledController.new
    @controller.cache_store.clear
  end

  test "caches actions" do
    get :random
    cached = @response.body
    get :random
    @response.body.should == cached
  end

  test "it has esi disabled" do
    @controller.esi_enabled.should == nil
  end

  test "it renders correctly" do
    get :show, :in_action => 'A', :in_esi => 'B'
    @response.body.should == "A B"
  end

  test "it renders old esi-partial when action was cached" do
    get :show, :in_action => 'A', :in_esi => 'B'
    get :show, :in_action => 'X', :in_esi => 'C'
    @response.body.should == "A B"
  end

  test "it renders up-to-date esi-partial when action was not cached" do
    get :uncached, :in_action => 'X', :in_esi => 'C'
    @response.body.should == "X C"
  end

  test "it does not render esi includes" do
    get :test_filter
    @response.body.should == '<esi:include src="no_change"/>'
  end

  test "it renders old esi-partial with hash" do
    get :with_hash, :in_esi => 'C'
    get :with_hash, :in_esi => 'D'
    @response.body.should == "From hash: C"
  end
end


class EsiEnabledController < EsiDisabledController
  enable_esi

  def test_filter
  end

  def send_a_file
    send_file "VERSION"
  end
end

class EsiEnabledTest < ActionController::TestCase
  def setup
    @controller = EsiEnabledController.new
    @controller.cache_store.clear
  end

  test "caches actions" do
    get :random
    cached = @response.body
    get :random
    @response.body.should == cached
  end

  test "it has esi enabled" do
    @controller.esi_enabled.should == true
  end

  test "it renders correctly" do
    get :show, :in_action => 'A', :in_esi => 'B'
    @response.body.strip.should == "A B"
  end

  test "it up-to-date esi partial when action was cached" do
    get :show, :in_action => 'A', :in_esi => 'B'
    get :show, :in_action => 'X', :in_esi => 'C'
    @response.body.strip.should == "A C"
  end

  test "it renders up-to-date esi-partial when action was not cached" do
    get :uncached, :in_action => 'X', :in_esi => 'C'
    @response.body.strip.should == "X C"
  end

  test "it renders up-to-date esi-partial with hash" do
    get :with_hash, :in_esi => 'C'
    get :with_hash, :in_esi => 'D'
    @response.body.should == "From hash: D"
  end

  test "it can serialize arbitrary data" do
    data = {'src' => 'something else', 1 => :x, 2 => ['"','/','___----']}
    get :serialize, :render_data => data
    @response.body.strip.should == data.inspect
  end

  test "it can send a file" do
    get :send_a_file
    @response.body.should == File.read('VERSION')
  end
end

class TestEasyEsi < ActionController::TestCase
  test "it has a VERSION" do
    EasyEsi::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
