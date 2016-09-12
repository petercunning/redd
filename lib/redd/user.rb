# frozen_string_literal: true

require_relative 'model'

module Redd
  # Holds information about a user.
  class User < Model
    # This method is quite helpful for a lot of API calls, which expect a
    # username. This way, we allow both User objects and usernames.
    # @return [String] the String representation of the user
    def to_s
      name
    end
  end
end
