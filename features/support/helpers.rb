module Helpers
  def gets
    interactions[:get] ||= []
  end

  def posts
    interactions[:post] ||= []
  end

  def puts
    interactions[:put] ||= []
  end

  def deletes
    interactions[:delete] ||= []
  end

  def interactions
    @interactions ||= {}
  end

  def restart_server(port: 3001)
    stop_server
    start_server(port: port)
  end

  def start_server(port: 3001)
    Bundler.with_clean_env do
      raise "couldn't start server" unless system "RAILS_ENV=development cd fixtures/server && rake db:reset && bundle exec thin start -C config/thin.yml -p #{port}"
    end

    eventually { RestClient.head("http://localhost:#{port}") }
  end

  def stop_server
    Bundler.with_clean_env do
      system "RAILS_ENV=development cd fixtures/server && bundle && bundle exec thin stop -C config/thin.yml"
    end
  end

  def eventually
    give_up_at = Time.now + 5
    success = false
    message = "Gave up."

    while Time.now < give_up_at && success == false
      begin
        success = yield

      rescue Exception => e
        message = e
      end

      sleep 0.05 unless success
    end

    unless success
      raise message
    end
  end
end

World Helpers