# frozen_string_literal: true

require 'http'
require_relative 'utilities'
require_relative 'options'

module Redd
  # The base class for anything that makes requests.
  class Client
    include Utilities

    # Create a new API client from the given config.
    # @param config [#to_h] the configuration options
    # @yield the options object to allow setting options in a block
    # @see Options::ClientOptions
    def initialize(config = {}, &block)
      @config = Options::ClientOptions.new(config, &block)
    end

    private

    # A persistent connection or one created lazily. You have no idea how
    # awesome immutability is.
    #
    # P.S. Caching is done later in subclasses.
    def connection
      HTTP.persistent(@config.endpoint)
          .headers('User-Agent' => @config.user_agent)
    end

    # Make a request using HTTP.rb.
    # @param verb [:get, :post, :patch, :delete] the HTTP verb to use
    # @param path [String] the path relative to the endpoint
    # @param params [Hash] a hash of params to send with the request
    # @return [HTTP::Response]
    def request(verb, path, params = {})
      type = (verb == :get ? :params : :form)
      connection.request(verb, URI.join(@config.endpoint, path), type => params)
    end

    # Make a request and parse it as JSON.
    # @return [Hash]
    # @see #request
    def json(*args)
      response_body = request(*args).body.to_s
      begin
        JSON.parse(response_body, symbolize_names: true)
      rescue JSON::ParserError => e
        raise JSONError.new(e.message, response_body)
      end
    end

    # Initialize a model under the Redd namespace with the JSON response.
    # @param type [#to_s] the type to deserialize into
    # @return [Model] the model object
    # @see #request
    def model(type, *args)
      # FIXME: convert snake case to pascal case, not just do a #capitalize.
      Redd.const_get(camelize(type)).new(self, json(*args))
    end
  end
end
