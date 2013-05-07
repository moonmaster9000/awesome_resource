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
    attributes.keys.each do |key|
      attributes[key.to_s] = attributes.delete key if key != key.to_s
    end

    @attributes = attributes
  end

  def method_missing(method_name, *args, &block)
    method_name = method_name.to_s

    if attributes.has_key?(method_name)
      attributes[method_name]
    else
      super
    end
  end

  def respond_to?(method_name)
    attributes.has_key?(method_name.to_s) || super
  end

  def ==(other_resource)
    attributes.keys.all? do |key|
      other_resource.respond_to?(key) && other_resource.send(key) == send(key)
    end
  end

  def attributes
    @attributes
  end
end