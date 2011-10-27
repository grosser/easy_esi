require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default do
  sh "RAILS=3.0.10 && (bundle || bundle install) && bundle exec rake test"
  sh "RAILS=3.1.0  && (bundle || bundle install) && bundle exec rake test"
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
