module AwesomeResource
  class SiteRequired < StandardError; end

  class Configuration
    def site(lazy_value=nil)
      @site = lazy_value if lazy_value
      if @site.respond_to?(:call)
        @site.call
      else
        raise SiteRequired
      end
    end
  end
end