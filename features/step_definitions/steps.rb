Given /^a rails site exists accepting posts at "([^"]*)"$/ do |endpoint|
end

When /^I call `create` on an Article model:$/ do |code|
  sleep 5; eval code
end

Then /^the Article model should successfully POST the following JSON to "([^"]*)":$/ do |endpoint, json|
  posts.should include_interaction(
    endpoint: endpoint,
    request_body: json,
    response_status: 201
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