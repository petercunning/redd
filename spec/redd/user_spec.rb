# frozen_string_literal: true

require 'redd/user'

describe Redd::User do
  describe '#to_s' do
    it 'returns the username' do
      username = 'Mustermind'
      user = model(Redd::User, name: username)
      expect(user.to_s).to eq(username)
    end
  end
end
