require "delegate"

module AwesomeResource
  class Attributes < SimpleDelegator
    def initialize(attributes={})
      @attributes = standardize_keys! attributes
      super @attributes
    end

    def accessor_for_method_name(method_name)
      if method_name["="]
        ->(attribute_value) { self[method_name[0...-1]] = attribute_value }
      else
        -> { self[method_name] }
      end
    end

    def [](key)
      validate_key_exists(key)
      attributes[standardized_key(key)]
    end

    def []=(key, value)
      validate_key_exists(key)
      attributes[standardized_key(key)] = value
    end

    def has_key?(key)
      attributes.has_key?(standardized_key(key))
    end

    def to_hash
      attributes
    end

    private
    attr_reader :attributes

    def validate_key_exists(key)
      raise "Unknown attribute '#{key}'" unless has_key? key
    end

    def standardized_key(key)
      key.to_s
    end

    def standardize_keys!(hash)
      hash.keys.each do |key|
        hash[standardized_key(key)] = hash.delete(key) if key != standardized_key(key)
      end

      hash
    end
  end
end