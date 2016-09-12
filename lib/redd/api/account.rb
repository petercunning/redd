# frozen_string_literal: true

require_relative '../api'
require_relative '../user' # FIXME: Have #model require the model class

module Redd
  class API
    # Methods related to the logged-in account.
    class Account < API
      # @return [User] the currently logged-in user
      def me
        model(:user, :get, 'api/v1/me')
      end
    end
  end
end
