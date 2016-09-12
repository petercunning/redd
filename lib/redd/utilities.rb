# frozen_string_literal: true

module Redd
  # Helpful utility functions to include in classes that need them.
  # :nodoc:
  # :nocov:
  module Utilities
    private

    # Convert a string to camel case.
    # @param snake_case [String] the string to camelize
    # @return [String] the camelized version of the string
    # @see http://stackoverflow.com/a/24917606/898577
    def camelize(snake_case)
      snake_case.to_s.split('_').collect(&:capitalize).join
    end

    # Convert a CamelCase string to underscore_case
    # @param camel_case [String] the CamelCase string
    # @return the converted string
    def underscore(camel_case)
      camel_case.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end

    # Remove the namespacing elements of a class name.
    # @param class_name [String] the class name to demodulize
    # @return [String] the demodulized string
    def demodulize(class_name)
      class_name.split('::').last
    end
  end
  # :nocov:
  # :nodoc:
end
