require 'rake/testtask'
Rake::TestTask.new(:default) do |test|
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'easy_esi'
    gem.summary = "Rails: Cached pages with updated partials"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
    gem.add_runtime_dependency 'activerecord'
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
