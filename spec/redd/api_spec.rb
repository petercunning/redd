# frozen_string_literal: true

require 'redd/api'

describe Redd::API do
  describe '.namespace' do
    subject do
      Class.new(Redd::API) do
        namespace :foo
        namespace 'bar'
      end
    end

    it 'adds the option to .namespaces' do
      expect(subject.namespaces).to include(:foo, :bar)
    end

    it 'creates an attr_accessor for the option' do
      instance = subject.new(access: double('Access'))
      expect(instance).to respond_to(:foo)
      expect(instance).to respond_to(:bar)
    end

    it 'loads and initializes the namespace on access' do
      instance = Redd::API.new(access: double('Access'))
      expect(instance.account).to be_a(Redd::API::Account)
    end

    it "sets the namespace's options to the options supplied to it" do
      options = Redd::Options::APIOptions.new(
        user_agent: 'Hi',
        access: instance_double(Redd::Access)
      )
      expect(Redd::API::Account).to receive(:new).with(options)
      Redd::API.new(options).account
    end
  end
end
