$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
name = "easy_esi"
require "#{name}/version"

Gem::Specification.new name, EasyEsi::VERSION do |s|
  s.authors = "Michael Grosser"
  s.email = "michael@grosser.it"
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://github.com/grosser/#{name}"
  s.summary = "Rails: Cached pages with updated partials"
  s.add_runtime_dependency "actionpack", ">= 2"
  s.license = "MIT"
end

