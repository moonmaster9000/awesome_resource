Gem::Specification.new do |s|
  s.author = "Matthew Kane Parker"
  s.version = File.read "VERSION"
  s.license = "Public Domain"
  s.name = "awesome_resource"
  s.summary = "An awesome implementation of ActiveResource"

  s.add_dependency "activesupport"
  s.add_dependency "rest-client"

  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rails', '3.2.13'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock', '~> 1.9.0'
  s.add_development_dependency 'debase'
  s.add_development_dependency 'ruby-debug-ide'
end