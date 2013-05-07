require "active_support/concern"
require "active_support/core_ext/string/inflections"
require "rest_client"
require "json"

module AwesomeResource
  extend ActiveSupport::Concern

  module ClassMethods
    def create(attributes={})
      RestClient.post("http://localhost:3001/#{self.name.underscore.pluralize}", JSON.generate(self.name.underscore => attributes), "Content-Type" => "application/json")
    end

    def all
      response = RestClient.get("http://localhost:3001/#{self.name.underscore.pluralize}", "ContentType" => "application/json")
      JSON.parse(response)[self.name.underscore.pluralize].map do |resource|
        new(resource)
      end
    end
  end

  def initialize(attributes={})
    @attributes = attributes
  end

  def method_missing(method_name, *args, &block)
    @attributes[method_name.to_s]
  end
end