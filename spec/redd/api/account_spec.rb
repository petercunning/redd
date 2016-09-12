# frozen_string_literal: true

require 'redd/api/account'

describe Redd::API::Account do
  describe '#me' do
    let :client do
      Redd::API::Account.new(access: double('Access', access_token: ''))
    end

    it 'returns a User from the response' do
      stub_api(:get, 'api/v1/me') { { name: 'Mustermind' } }
      user = client.me
      expect(user).to be_a(Redd::User)
      expect(user.name).to eq('Mustermind')
    end
  end
end
