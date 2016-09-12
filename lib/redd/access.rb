# frozen_string_literal: true

require_relative 'model'

module Redd
  # Holds the access token and other details for OAuth2.
  class Access < Model
    # @return [Time] the time when the object was created
    attr_reader :created_at

    def initialize(*args)
      super
      @created_at = Time.now
    end

    # @return [Boolean] whether the access can be refreshed
    def refreshable?
      attributes.key?(:refresh_token)
    end

    # @return [Time] time when the access expires
    def expires_at
      created_at + expires_in
    end

    # @param grace_period [Boolean] return true slightly before expiry
    # @return [Boolean] whether the access is expired
    def expired?(grace_period = true)
      Time.now + (grace_period ? 300 : 0) >= expires_at
    end

    # Check if the user has the given scope.
    # @param check_scope [String] the name of the scope to check for
    # @return [Boolean] whether the user has the given scope
    def scope?(check_scope)
      # TODO: check if scopes are part of a list of valid scopes first?
      return true if scope == '*'
      scope.split(',').include?(check_scope.to_s)
    end
  end
end
