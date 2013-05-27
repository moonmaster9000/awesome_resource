require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'fixtures/cassettes'
  c.default_cassette_options = { :record => :all }

  c.allow_http_connections_when_no_cassette = true
end

Before do |scenario|
  VCR.insert_cassette scenario.name, record: :all
end

After do
  VCR.eject_cassette
end