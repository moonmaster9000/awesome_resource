require 'awesome_resource/attributes'
require 'awesome_resource/client'
require "active_support/core_ext/string/inflections"
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
      new(attributes).tap &:save
    end

    def find(id)
      response = AwesomeResource.client.get(location: resource_endpoint(id))
      new(response.body[resource_name])
    end

    def collection_endpoint
      "#{site}#{collection_name}"
    end

    def resource_endpoint(id)
      "#{collection_endpoint}/#{id}"
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
      response = AwesomeResource.client.get(location: collection_endpoint)

      response.body[collection_name].map do |resource|
        new(resource)
      end
    end
  end

  attr_accessor :errors

  def initialize(attributes={})
    @attributes = AwesomeResource::Attributes.new(attributes)
    @errors     = AwesomeResource::Attributes.new
  end

  def valid?
    errors.empty?
  end

  def invalid?
    !valid?
  end


  def method_missing(method_name, *args)
    awesome_attributes.accessor_for_method_name(method_name).call(*args)
  end

  def respond_to?(method_name)
    awesome_attributes.has_key?(method_name) || super
  end

  def ==(other_resource)
    attributes.keys.all? do |key|
      other_resource.attributes.has_key?(key) && other_resource.send(key) == send(key)
    end
  end

  def attributes
    @attributes.to_hash
  end

  def save
    if awesome_attributes.has_key?(:id) &&
      self.id
      method = :put
      endpoint = self.class.resource_endpoint(self.id)
    else
      method = :post
      endpoint = self.class.collection_endpoint
    end

    response = AwesomeResource.client.send(method,
      location: endpoint,
      body: { self.class.resource_name => attributes }
    )

    if response.status == 201
      @attributes = AwesomeResource::Attributes.new(response.body)
    elsif response.status == 422
      self.errors = AwesomeResource::Attributes.new response.body["errors"]
    end
  end

  private
  def awesome_attributes
    @attributes
  end
end