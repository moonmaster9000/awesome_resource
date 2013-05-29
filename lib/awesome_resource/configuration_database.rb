require "awesome_resource/configuration"

module AwesomeResource
  class ConfigurationDatabase
    def method_missing(method_name, *args, &block)
      configurations["default"].send method_name, *args, &block
    end

    def test(&block)
      configurations["default"].test &block
    end

    def config_for(model="default", &block)
      model = model.to_s

      if block
        configurations[model] ||= Configuration.new
        configurations[model].instance_eval &block
      else
        configurations[model] || configurations["default"]
      end
    end

    private
    def configurations
      return @configurations if @configurations

      @configurations = {}
      @configurations["default"] = Configuration.new
      @configurations
    end
  end
end

