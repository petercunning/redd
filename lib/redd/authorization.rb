# frozen_string_literal: true

require_relative 'client'
require_relative 'options'

module Redd
  # Base class for authorization strategies.
  class Authorization < Redd::Client
    # Create a new API client from the given config.
    # @param config [#to_h] the configuration options
    # @yield the options object to allow setting options in a block
    # @see Options::AuthorizationOptions
    def initialize(config = {}, &block)
      @config = Options::AuthorizationOptions.new(config, &block)
    end

    # Authorize the client and return the created Access.
    # @return [Access]
    def authorize
      raise '`authorize` is not defined for the base class!'
    end

    private

    def connection
      @connection ||=
        super.basic_auth(user: @config.client_id, pass: @config.secret)
    end
  end
end
