Before do
  scenario_interactions = interactions

  AwesomeResource.reset_config!

  VCR.configuration.clear_hooks

  VCR.configure do |c|
    c.after_http_request(->(_) { true }) do |request, response|
      scenario_interactions[request.method] ||= []
      scenario_interactions[request.method] << {request: request, response: response}
    end
  end
end
