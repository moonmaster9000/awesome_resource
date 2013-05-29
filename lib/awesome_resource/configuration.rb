module AwesomeResource
  class SiteRequired < StandardError; end

  class Configuration
    def test(&block)
      configure_for_environment "test", &block
    end

    def method_missing(method_name, *args, &block)
      configure_for_environment method_name, &block
    end

    def site(lazy_value=nil)
      @site ||= {}

      if lazy_value
        @site[for_environment] = lazy_value
      else
        if @site[current_environment].respond_to?(:call)
          @site[current_environment].call
        elsif @site["default"].respond_to?(:call)
          @site["default"].call
        else
          raise SiteRequired
        end
      end
    end

    private
    attr_writer :for_environment

    def configure_for_environment(environment, &block)
      self.for_environment = environment.to_s
      instance_eval &block
      self.for_environment = nil
    end

    def current_environment
      AwesomeResource.env
    end

    def for_environment
      @for_environment || "default"
    end

  end
end