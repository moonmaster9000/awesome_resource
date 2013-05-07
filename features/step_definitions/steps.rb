Given /^a rails site exists accepting posts at "([^"]*)"$/ do |endpoint|
end

When /^I call create on an Article model:$/ do |code|
  sleep 5; eval code
end

Then /^the Article model should successfully POST the following JSON to "([^"]*)":$/ do |endpoint, json|
  posts.should include_request endpoint, json
end

When /^I call the `all` method on the Article model$/ do
  @all = Article.all
end

Then /^the rails app should respond to a GET request to "([^"]*)" with the following JSON:$/ do |endpoint, json|
  gets.should include_response endpoint, json
end

When /^the `all` method should return an array containing a single article responding to methods that correspond to the JSON properties$/ do
  @all.first.id.should == 1
  @all.first.title.should == "foo"
end

def gets
  interactions[:get] ||= []
end

def posts
  interactions[:post] ||= []
end

RSpec::Matchers.define :include_response do |endpoint, json|
  match do |http_interactions|
    http_interactions.any? do |interaction|
      interaction[:request].uri.to_s == endpoint &&
      JSON.parse(interaction[:response].body).should == JSON.parse(json)
    end
  end
end

RSpec::Matchers.define :include_request do |endpoint, json|
  match do |http_interactions|
    http_interactions.any? do |interaction|
      interaction[:request].uri.to_s == endpoint &&
      JSON.parse(interaction[:request].body).should == JSON.parse(json)
    end
  end
end

def interactions
  Interactions.interactions
end


Before do
  Interactions.reset!
  stop_server
  start_server
end

def start_server
  Bundler.with_clean_env do
    raise "couldn't start server" unless system "RAILS_ENV=development cd fixtures/server && rake db:reset && bundle exec thin start -C config/thin.yml"
  end
end

def stop_server
  Bundler.with_clean_env do
    system "RAILS_ENV=development cd fixtures/server && bundle exec thin stop -C config/thin.yml"
  end
end