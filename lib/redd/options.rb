# frozen_string_literal: true

require_relative 'version'

module Redd
  # A convenience class to easily assign options. Can "extend" any other class
  # if provided in the constructor
  class Options
    # @return [Array<Symbol>] an array of options defined for the class
    def self.options
      @options ||= []
    end

    # Define an option with the given name.
    # @param names [Array<Symbol>] an array of attributes to define
    # @return [Array<Symbol>] the attributes that were defined
    # @!macro define_option
    #   @!attribute [rw] $1
    def self.define_option(*names)
      names.each do |name|
        attr_accessor name
        options << name
      end
    end

    # Add the current class's options to the inherited one's.
    def self.inherited(subclass)
      subclass.options.concat(options)
    end

    # Create a new Options object from a hash or a block.
    # @param attributes [#to_h] the attributes to supply
    # @yield [c] yields itself to set options via a block
    def initialize(attributes = {})
      assign_attributes(attributes.to_h)
      yield self if block_given?
      before_freeze
      freeze
    end

    # @return [Hash] a hash representation of the object and its options
    def to_h
      Hash[self.class.options.map { |ivar| [ivar, send(ivar)] }]
        .reject { |_, v| v.nil? }
    end

    def ==(other)
      other.is_a?(self.class) && to_h == other.to_h
    end

    private

    # Call attr_writer methods for each Hash pair.
    def assign_attributes(attributes)
      attributes.each_pair do |attr_name, value|
        send(:"#{attr_name}=", value)
      end
    end

    # Do some stuff before we freeze the object.
    def before_freeze
    end

    # A container to hold configuration options for clients.
    class ClientOptions < Options
      # The default user agent to use when none is provided.
      DEFAULT_USER_AGENT = "Ruby:Redd (Default):v#{VERSION}"

      # @return [String] the user agent to use when contacting reddit.
      define_option :user_agent

      # @return [String] the URI to make requests to.
      define_option :endpoint

      private

      def before_freeze
        @user_agent ||= DEFAULT_USER_AGENT
      end
    end

    # Options for authorizing a client.
    class AuthorizationOptions < ClientOptions
      # The endpoint to connect to when getting an access token.
      DEFAULT_AUTH_ENDPOINT = 'https://www.reddit.com'

      # @return [String] the client ID to make requests with.
      define_option :client_id

      # @return [String] the client secret value.
      define_option :secret

      # @return [String] the username to user for script authorization. The user
      #   must be registered as a developer for the app.
      define_option :username

      # @return [String] the password for the given username.
      define_option :password

      # Output the class's details while omitting sensitive details like the
      # client secret or script password to prevent logging them accidentally.
      # @return [String]
      def inspect
        inner_contents =
          instance_variables
          .reject { |var| %i(@secret @password).include?(var) }
          .map { |var| "#{var}=#{instance_variable_get(var).inspect}" }
          .join(', ')
        "#<#{self.class.name} #{inner_contents}>"
      end

      private

      def before_freeze
        super
        @endpoint ||= DEFAULT_AUTH_ENDPOINT
      end
    end

    # The default options for the API client.
    class APIOptions < ClientOptions
      # The endpoint to make API requests to.
      DEFAULT_API_ENDPOINT = 'https://oauth.reddit.com'

      # @return [Access] the access information to use with this client
      define_option :access

      private

      def before_freeze
        super
        raise '`access` must be provided!' unless access
        @endpoint ||= DEFAULT_API_ENDPOINT
      end
    end
  end
end
