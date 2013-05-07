require "active_support/concern"
require "active_support/core_ext/string/inflections"
require "rest_client"
require "json"

module AwesomeResource
  extend ActiveSupport::Concern

  module ClassMethods
    def create(attributes={})
      RestClient.post(collection_endpoint, JSON.generate(resource_name => attributes), "Content-Type" => "application/json")
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
      response = RestClient.get(collection_endpoint, "ContentType" => "application/json")

      JSON.parse(response)[collection_name].map do |resource|
        new(resource)
      end
    end
  end

  def initialize(attributes={})
    @attributes = AwesomeResource::Attributes.new(attributes)
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

  class Attributes
    def initialize(attributes)
      @attributes = standardize_keys! attributes
    end

    def [](key)
      attributes[standardized_key(key)]
    end

    def keys
      attributes.keys
    end

    def has_key?(key)
      attributes.has_key?(standardized_key(key))
    end

    def to_hash
      attributes
    end

    private
    attr_reader :attributes

    def standardized_key(key)
      key.to_sym
    end

    def standardize_keys!(hash)
      hash.keys.each do |key|
        hash[standardized_key(key)] = hash.delete(key) if key != standardized_key(key)
      end

      hash
    end
  end
end