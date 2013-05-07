require 'vcr'
module Interactions
  extend self

  def interactions
    @interactions ||= {}
  end

  def reset!
    @interactions = nil
  end
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'fixtures/cassettes'
  c.default_cassette_options = { :record => :all }

  c.after_http_request(->(_){ true }) do |request, response|
    Interactions.interactions[request.method] ||= []
    Interactions.interactions[request.method] << {request: request, response: response}
  end
end

Before do |scenario|
  VCR.insert_cassette scenario.name, record: :all
end

After do
  VCR.eject_cassette
end