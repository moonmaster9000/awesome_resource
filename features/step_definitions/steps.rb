Given %r{^a rails site exists accepting posts at "http://localhost:3001/articles"$} do
  restart_server(port: 3001)
end

When /^I call `create` on an Article model:$/ do |code|
  eval code
end

Then /^the Article model should successfully POST the following JSON to "([^"]*)":$/ do |endpoint, json|
  posts.should include_interaction(
    endpoint: endpoint,
    request_body: json,
    status: "201"
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

Then(/^the Article model should POST the following JSON to "([^"]*)":$/) do |endpoint, body|
  posts.should include_interaction(
    endpoint: endpoint,
    request_body: body
  )
end

When(/^the endpoint should respond with a (\d+) with the following body:$/) do |status, body|
  posts.should include_interaction(
    status: status,
    response_body: body
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

When(/^the server returns a (\d+) response with the following body:$/) do |status_code, body|
  gets.should include_interaction(
    status: status_code,
    response_body: body
  )
end

Then(/^the find method should return a resource equivalent to the following:$/) do |code|
  @result.should == eval(code)
end

When(/^the server returns a (\d+) response from a GET request to "(.*)"$/) do |status, endpoint|
  gets.should include_interaction(
    status: status,
    endpoint: endpoint
  )
end

Then(/^the find method should raise an AwesomeResource::ResourceNotFound exception$/) do
  @result.class.should == AwesomeResource::ResourceNotFound
end

When(/^I update the article:$/) do |code|
  @result = begin
    eval code
  rescue Exception => e
    e
  end
end

Then(/^AwesomeResource should PUT the following body to "(.*)"$/) do |endpoint, body|
  puts.should include_interaction(
    endpoint: endpoint,
    request_body: body
  )
end

When(/^the server should return a (\d+) response to the PUT to "(.*)"$/) do |status_code, endpoint|
  puts.should include_interaction(
    endpoint: endpoint,
    status: status_code
  )
end

When(/^the server returns a (\d+) response from a PUT request to "(.*)"$/) do |status, endpoint|
  puts.should include_interaction(
    endpoint: endpoint,
    status: status
  )
end

Then(/^the save method should raise an AwesomeResource::ResourceNotFound exception$/) do
  @result.class.should == AwesomeResource::ResourceNotFound
end

Given(/^there are no articles on the server$/) do
end

When(/^I call the destroy method on this article instance:$/) do |code|
  eval code
end

Then(/^AwesomeResource should send a DELETE request to "(.*)"$/) do |endpoint|
  deletes.should include_interaction(
    endpoint: endpoint
  )
end

When(/^the server should return a (\d+) response to the DELETE to "(.*)"$/) do |status, endpoint|
  deletes.should include_interaction(
    endpoint: endpoint,
    status: status
  )
end

When(/^`Article.find\(1\)` should raise a ResourceNotFound exception$/) do
  expect { Article.find(1) }.to raise_exception AwesomeResource::ResourceNotFound
end

Given(/^I do not configure any sites for AwesomeResource to connect to$/) do
end

When(/^I attempt to create a resource:$/) do |code|
  @result = begin
    eval code
  rescue Exception => e
    e
  end
end

Then(/^AwesomeResource should raise a SiteRequired exception$/) do
  @result.class.should == AwesomeResource::SiteRequired
end

Given(/^a rails site exists at "http:\/\/localhost:3002\/"$/) do
  restart_server(port: 3002)
end

Then(/^AwesomeResource should POST the following body to "(.*)"$/) do |url, body|
  @result.class.ancestors.should_not include Exception

  posts.should include_interaction(
    endpoint: url,
    request_body: body
  )
end

When(/^I create a resource:$/) do |code|
  eval code
end

When(/^I have configured AwesomeResource to post to that site:$/) do |code|
  eval code
end

Given(/^I change the default 'Rails.env' environment lookup to the following:$/) do |code|
  eval code
end

When(/^I configure a default site for AwesomeResource for different environments:$/) do |code|
  eval code
end