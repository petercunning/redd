# frozen_string_literal: true

require_relative 'error'

module Redd
  # The base for a model, quite similar to ActiveModel or Hashie, except
  # it's immutable.
  class Model
    # @return [Client] the client being used by the model
    attr_reader :client

    # @return [Hash] the attributes the model was initialized with
    attr_reader :attributes

    # @return [Hash] the hash representation of the model
    alias to_h attributes

    # Create a new Model from the given attributes.
    # @param client [Client] a client for convenience requests
    # @param attributes [Hash] the attributes to create the model with
    def initialize(client, attributes = {})
      # TODO: create atrribute accessors on initialize? (optimization)
      @client = client
      @attributes = attributes.freeze
    end

    # Check if the model has a given attribute.
    # @param [Symbol] attribute the attribute name
    # @return [Boolean] whether the attribute exists
    def attribute?(attribute)
      @attributes.key?(attribute.to_sym)
    end

    # Internal: Check if the object has a given property.
    def respond_to_missing?(meth, *args)
      attribute?(meth) || super
    end

    # Internal: Get a given property from an object if it exists.
    def method_missing(prop, *args, &block)
      return super unless args.empty? && !block_given? && attribute?(prop)
      @attributes[prop.to_sym]
    end
  end
end
