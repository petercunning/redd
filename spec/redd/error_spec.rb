# frozen_string_literal: true

require 'redd/error'
require 'http'

# Mock up a response with a given status code.
def response_with_code(status_code)
  status = instance_double(HTTP::Response::Status, code: status_code)
  instance_double(HTTP::Response, status: status)
end

describe Redd::ResponseError do
  describe '#retryable?' do
    context 'when the API call is not found (403)' do
      it 'should not be retryable' do
        error = Redd::ResponseError.new(response_with_code(403), '')
        expect(error).not_to be_retryable
      end
    end

    context 'when the API call is not found (404)' do
      it 'should not be retryable' do
        error = Redd::ResponseError.new(response_with_code(404), '')
        expect(error).not_to be_retryable
      end
    end

    context 'when reddit has a hiccup (500..505)' do
      it 'should be retryable' do
        (500..505).each do |status_code|
          error = Redd::ResponseError.new(response_with_code(status_code), '')
          expect(error).to be_retryable
        end
      end
    end
  end
end

describe Redd::JSONError do
  describe '#cause' do
    it 'returns the cause it was created with' do
      cause = 'Bad JSON at 123'
      error = Redd::JSONError.new(cause, response_with_code(500), '')
      expect(error.cause).to eq(cause)
    end
  end
end
