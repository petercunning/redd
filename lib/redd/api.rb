# frozen_string_literal: true

require_relative 'client'
require_relative 'options'

module Redd
  # Base class for API methods.
  class API < Client
    include Utilities

    # @return [Array<String>] a list of the namespaces defined for the client
    def self.namespaces
      @namespaces ||= []
    end

    # Add a namespace for this client.
    # @param class_name [Symbol] the subclass to add as a namespace
    # @return [Symbol] the symbol of the method that was created
    # @!macro namespace
    #   @!attribute [r] $1
    def self.namespace(class_name)
      define_method(class_name) { load_or_return_namespace(class_name) }
        .tap { |class_symbol| namespaces << class_symbol }
    end

    # Hook to delete namespace methods on children.
    def self.inherited(subclass)
      namespaces.each { |ns| subclass.send(:undef_method, ns) }
    end

    # @return [API::Account]
    namespace :account

    # Create a new API client from the given config.
    # @param config [#to_h] the configuration options
    # @yield the options object to allow setting options in a block
    # @see Options::APIOptions
    def initialize(config = {}, &block)
      @config = Options::APIOptions.new(config, &block)
    end

    private

    # Not a lightweight method; load a namespace from the path and initialize
    # it. Returns the existing namespace if already loaded.
    # @param ns [String] the namespace as a snake_case string
    # @return [API] the namespace instance
    def load_or_return_namespace(ns)
      existing_defined_namespace = instance_variable_get("@_#{ns}")
      return existing_defined_namespace unless existing_defined_namespace.nil?

      # FIXME: Currently, we can only require a subclass after this class
      #   is fully defined. Unfortunately, this means that when things
      #   break, they break during runtime.
      require_relative "#{underscore(demodulize(self.class.name))}/#{ns}"
      klass = self.class.const_get(camelize(ns)).new(@config)
      instance_variable_set("@_#{ns}", klass)
    end

    def connection
      @connection ||= super.auth("Bearer #{@config.access.access_token}")
    end

    def request(verb, path, params = {})
      super(verb, path, { api_type: 'json', raw_json: 1 }.merge(params))
    end
  end
end
