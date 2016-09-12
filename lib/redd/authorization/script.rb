# frozen_string_literal: true

require_relative '../access'
require_relative '../authorization'

module Redd
  class Authorization
    # Authorization using the script method.
    class Script < Authorization
      # @see Authorization#authorize
      def authorize
        Access.new self, json(
          :post, '/api/v1/access_token',
          grant_type: 'password',
          username: @config.username,
          password: @config.password
        )
      end
    end
  end
end
