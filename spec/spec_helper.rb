# frozen_string_literal: true

require 'webmock/rspec'
require 'simplecov'
require 'uri'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__), '../lib')
require 'redd'

# This only lets through stubbed requests. This way, tests fail when the client
# makes a request to an unknown path.
WebMock.disable_net_connect!

# Fails if the coverage metrics fall since the last test run.
SimpleCov.refuse_coverage_drop
SimpleCov.start

# Initialize a model with a stubbed client.
def model(klass, **attributes)
  # We use the keyword splat so that empty params don't result in a hash
  # being sent through.
  klass.new(double('Client'), **attributes)
end

# Helper for stubbing API requests to https://oauth.reddit.com
def stub_api(verb, path, params = {})
  s = stub_request(verb, URI.join('https://oauth.reddit.com', path))
  s =
    if verb == :get
      s.with(query: hash_including(params))
    else
      s.with(body: URI.encode_www_form(params),
             headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    end
  s.to_return(body: (block_given? ? JSON.generate(yield) : ''),
              headers: { 'Content-Type' => 'application/json' })
end
