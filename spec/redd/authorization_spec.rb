# frozen_string_literal: true

require 'redd/authorization'

describe Redd::Authorization do
  describe '#authorize' do
    it "raises an error (cuz it ain't defined)" do
      expect { Redd::Authorization.new.authorize }.to raise_error
    end
  end
end
