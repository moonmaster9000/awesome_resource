require "socket"

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

    eventually { TCPSocket.new 'localhost', port }
  end

  def stop_server
    Bundler.with_clean_env do
      system "RAILS_ENV=development cd fixtures/server && kill -9 `cat tmp/pids/thin.pid`"
    end
  end

  def restart_proxy(options)
    stop_proxy
    start_proxy options
  end

  def stop_proxy
    Bundler.with_clean_env do
      system "cd fixtures/proxy && bundle exec thin stop -C thin.yml"
    end
  end

  def start_proxy(port: 4000, user: ->{ raise "user required" }.call, password: ->{ raise "password required" }.call)
    Bundler.with_clean_env do
      raise "couldn't start proxy" unless system "cd fixtures/proxy && PROXY_USER=#{user} PROXY_PASSWORD=#{password} bundle exec thin start -C thin.yml -p #{port}"
    end

    eventually { TCPSocket.new 'localhost', port }
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