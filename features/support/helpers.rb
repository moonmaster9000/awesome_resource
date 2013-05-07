module Helpers
  def gets
    interactions[:get] ||= []
  end

  def posts
    interactions[:post] ||= []
  end

  def interactions
    Interactions.interactions
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
end

World Helpers