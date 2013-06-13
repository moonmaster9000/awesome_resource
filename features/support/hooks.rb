server_rebooted = false

Before do
  unless server_rebooted
    Kernel.puts "rebooting server!"
    stop_server
    Bundler.with_clean_env do
      system "cd fixtures/server && bundle exec rake db:drop db:create db:migrate"
    end
    start_server
    server_rebooted = true
  end
end

Before("~@reset-server-ids") do
  Bundler.with_clean_env do
    AwesomeResource.config do
      site -> { "http://localhost:3001" }
    end

    Article.all.map &:destroy
  end
end

Before("@reset-server-ids") do
  stop_server
  Bundler.with_clean_env do
    system "cd fixtures/server && bundle exec rake db:drop db:create db:migrate"
  end
  start_server
end

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

