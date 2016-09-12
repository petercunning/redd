# frozen_string_literal: true

require 'redd/client'

describe Redd::Client do
  subject do
    Class.new(Redd::Client) do
      def hello
        request(:get, '/hello')
      end

      def world
        json(:get, '/world')
      end
    end
  end

  describe '#initialize' do
    context 'with a custom user_agent' do
      it 'makes requests with that user_agent' do
        request_stub = stub_request(:get, 'https://www.myurl.com/hello')
                       .with(headers: { 'User-Agent' => 'Ruby' })
        subject.new(user_agent: 'Ruby', endpoint: 'https://www.myurl.com').hello
        expect(request_stub).to have_been_requested
      end
    end

    context 'with a custom endpoint' do
      it 'makes requests to that endpoint' do
        request_stub = stub_request(:get, 'https://www.myurl.com/hello')
        subject.new(endpoint: 'https://www.myurl.com').hello
        expect(request_stub).to have_been_requested
      end
    end
  end

  it "raises an error if JSON was expected but JSON wasn't returned" do
    stub_request(:get, 'https://www.myurl.com/world')
      .to_return(body: '<h1>This is not JSON</h1> (obviously)',
                 headers: { 'Content-Type' => 'application/json' })
    expect { subject.new(endpoint: 'https://www.myurl.com').world }
      .to raise_error(Redd::JSONError)
  end
end
