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
        find_most_specific_site_for_current_environment
      end
    end
    
    def proxy(lazy_value=nil)
      @proxy ||= {}
      
      if lazy_value
        @proxy[for_environment] = lazy_value
      else
        find_most_specific_proxy_for_current_environment
      end
    end


    private
    attr_writer :for_environment

    def find_most_specific_site_for_current_environment
      if @site[current_environment].respond_to?(:call)
        @site[current_environment].call
      elsif @site["default"].respond_to?(:call)
        @site["default"].call
      else
        raise SiteRequired
      end
    end

    def find_most_specific_proxy_for_current_environment
      if @proxy[current_environment].respond_to?(:call)
        @proxy[current_environment].call
      elsif @proxy["default"].respond_to?(:call)
        @proxy["default"].call
      else
        nil
      end
    end
    
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