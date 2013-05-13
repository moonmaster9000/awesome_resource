$LOAD_PATH.unshift "./lib"

require 'awesome_resource'

require 'rspec/expectations'
World(RSpec::Matchers)

Dir["fixtures/models/*.rb"].each do |model|
  load model
end