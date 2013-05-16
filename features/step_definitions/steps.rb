Given /^a rails site exists accepting posts at "([^"]*)"$/ do |endpoint|
end

When /^I call `create` on an Article model:$/ do |code|
  eval code
end

Then /^the Article model should successfully POST the following JSON to "([^"]*)":$/ do |endpoint, json|
  posts.should include_interaction(
    endpoint: endpoint,
    request_body: json,
    response_status: "201"
  )
end

When /^I call the `all` method on the Article model$/ do
  Article.all
end

Then /^the rails app should respond to a GET request to "([^"]*)" with the following JSON:$/ do |endpoint, json|
  gets.should include_interaction(
    endpoint: endpoint,
    response_body: json
  )
end

Then /^the `all` method should return the equivalent of:$/ do |code|
  Article.all.should == eval(code)
end

When(/^the server requires article posts to contain a `title` attribute$/) do
end

Then(/^the Article model should POST the following JSON to "([^"]*)":$/) do |endpoint, payload|
  posts.should include_interaction(
    endpoint: endpoint,
    request_body: payload
  )
end

When(/^the endpoint should respond with a (\d+) with the following payload:$/) do |response_code, payload|
  posts.should include_interaction(
    response_status: response_code,
    response_body: payload
  )
end

When(/^the `create` method should return an instance of article with that error:$/) do |code|
  eval code
end

Given(/^an article resource exists at "http:\/\/localhost:3001\/articles\/1"$/) do
  Article.create(title: "foo")
end

When(/^I call \`(.*)`$/) do |code|
  @result = begin
    eval code
  rescue Exception => e
    e
  end
end

When(/^the server returns a (\d+) response with the following payload:$/) do |status_code, payload|
  gets.should include_interaction(
    response_status: status_code,
    response_body: payload
  )
end

Then(/^the find method should return a resource equivalent to the following:$/) do |code|
  @result.should == eval(code)
end

When(/^the server returns a (\d+) response from a GET request to "(.*)"$/) do |status, endpoint|
  gets.should include_interaction(
    response_status: status,
    endpoint: endpoint
  )
end

Then(/^the find method should raise an AwesomeResource::NotFound exception$/) do
  @result.class.should == AwesomeResource::NotFound
end