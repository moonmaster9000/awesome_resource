require "delegate"

module AwesomeResource
  class Attributes < SimpleDelegator
    def initialize(attributes={})
      @attributes = standardize_keys! attributes
      super @attributes
    end

    def [](key)
      attributes[standardized_key(key)]
    end

    def []=(key, value)
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