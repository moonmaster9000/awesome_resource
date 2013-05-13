require 'awesome_resource/attributes'
require 'awesome_resource/client'
require "active_support/core_ext/string/inflections"
require "rest_client"
require "json"

module AwesomeResource
  def self.included(base)
    base.extend ClassMethods
  end

  def self.client
    Client
  end

  module ClassMethods
    def create(attributes={})
      response = AwesomeResource.client.post(location: collection_endpoint, body: { resource_name => attributes })
      new(response.payload)
    end

    def collection_endpoint
      "#{site}#{collection_name}"
    end

    def collection_name
      resource_name.pluralize
    end

    def resource_name
      self.name.underscore
    end

    def site
      "http://localhost:3001/"
    end

    def all
      response = AwesomeResource.client.get(collection_endpoint)

      response.payload[collection_name].map do |resource|
        new(resource)
      end
    end
  end

  def initialize(attributes={})
    @attributes = AwesomeResource::Attributes.new(attributes)
  end

  def valid?
    errors.empty?
  end

  def invalid?
    !valid?
  end

  def method_missing(method_name, *args, &block)
    if attributes.has_key?(method_name)
      attributes[method_name]
    else
      super
    end
  end

  def respond_to?(method_name)
    attributes.has_key?(method_name) || super
  end

  def ==(other_resource)
    attributes.keys.all? do |key|
      other_resource.attributes.has_key?(key) && other_resource.send(key) == send(key)
    end
  end

  def attributes
    @attributes.to_hash
  end
end