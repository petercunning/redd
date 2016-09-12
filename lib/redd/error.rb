# frozen_string_literal: true

module Redd
  # An error caused by an error in the response. This includes response-specific
  # information, like the status code and body.
  class ResponseError < ::StandardError
    # @return [HTTP::Response] the HTTP response
    attr_reader :response

    # Create a new ResponseError from an HTTP::Response.
    # @param response [HTTP::Response] the response that caused the error
    def initialize(response, *args, &block)
      super(*args, &block)
      @response = response
    end

    # @return [Boolean] whether the error can be solved if you retry the request
    def retryable?
      (500..600).cover?(response.status.code)
    end
  end

  # An error occurred in parsing the response body as JSON.
  class JSONError < ResponseError
    # @return [String] the cause of the error reported by the JSON parser
    attr_reader :cause

    def initialize(cause, *args, &block)
      super(*args, &block)
      @cause = cause
    end
  end
end
