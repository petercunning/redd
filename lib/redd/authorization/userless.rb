# frozen_string_literal: true

require_relative '../access'
require_relative '../authorization'

module Redd
  class Authorization
    # Authorization strategy without a user.
    class Userless < Authorization
      # @see Authorization#authorize
      def authorize
        Access.new self, json(
          :post, '/api/v1/access_token',
          grant_type: 'client_credentials'
        )
      end
    end
  end
end
