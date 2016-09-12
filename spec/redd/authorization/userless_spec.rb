# frozen_string_literal: true

require 'redd/authorization/userless'
require 'redd/options'
require 'uri'

describe Redd::Authorization::Userless do
  describe '#authorize' do
    it 'returns an Access' do
      options = Redd::Options::AuthorizationOptions.new do |opts|
        opts.client_id = 'CLIENT_ID'
        opts.secret    = 'SECRET'
      end
      access_token = 'ACCESS_TOKEN'
      client = Redd::Authorization::Userless.new(options)

      stub_request(:post, 'https://www.reddit.com/api/v1/access_token')
        .with(body: URI.encode_www_form(grant_type: 'client_credentials'),
              basic_auth: [options.client_id, options.secret])
        .to_return(body: %({"access_token":"#{access_token}"}),
                   headers: { 'Content-Type' => 'application/json' })

      access = client.authorize
      expect(access).to be_a(Redd::Access)
      expect(access.access_token).to eq(access_token)
    end
  end
end
