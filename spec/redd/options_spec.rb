# frozen_string_literal: true

require 'redd/options'

describe Redd::Options do
  subject do
    Class.new(Redd::Options) { define_option :a, :b }
  end

  describe '.define_option' do
    it 'adds the option to .options' do
      expect(subject.options).to include(:a)
      expect(subject.options).to include(:b)
    end

    it 'creates an attr_accessor for the option' do
      subject.new do |opts|
        expect(opts).to respond_to(:a)
        expect(opts).to respond_to(:a=)
        expect(opts).to respond_to(:b)
        expect(opts).to respond_to(:b=)
      end
    end
  end

  describe '.included' do
    it 'adds the parent attributes to the child on inheritance' do
      child = Class.new(subject) { define_option :c }
      expect(child.options).to include(:a, :b, :c)
    end
  end

  describe '#initialize' do
    context 'with no arguments' do
      it 'should not raise an error' do
        expect { subject.new }.not_to raise_error
      end

      it 'should be frozen' do
        expect(subject.new).to be_frozen
      end
    end

    context 'with a hash of arguments' do
      it 'calls the appropriate setters' do
        expect_any_instance_of(subject).to receive(:a=).with(1)
        expect_any_instance_of(subject).to receive(:b=).with(2)
        subject.new(a: 1, b: 2)
      end

      it 'has the correct getters' do
        instance = subject.new(a: 1, b: 2)
        expect(instance.a).to eq(1)
        expect(instance.b).to eq(2)
      end
    end

    context 'with a block' do
      it 'yields itself' do
        subject.new do |yield_arg|
          expect(yield_arg).to be_an_instance_of(subject)
        end
      end

      it 'has the correct getters' do
        instance = subject.new do |opts|
          opts.a = 1
          opts.b = 2
        end
        expect(instance.a).to eq(1)
        expect(instance.b).to eq(2)
      end
    end
  end

  describe '#to_h' do
    it 'returns a hash representation of the object' do
      instance = subject.new(a: 1) { |opts| opts.b = 2 }
      expect(instance.to_h).to eq(a: 1, b: 2)
    end
  end

  describe '#==' do
    it 'matches itself' do
      options = subject.new(a: 1, b: 2)
      expect(options).to eq(options)
    end

    it 'does not match another class type' do
      expect(subject.new(a: 1, b: 2)).not_to eq('Hello, everybody!')
    end

    it 'matches an options instance with the same attributes' do
      expect(subject.new(a: 1, b: 2)).to eq(subject.new(a: 1, b: 2))
    end

    it 'does not match an options instance with different attributes' do
      expect(subject.new(a: 1, b: 2)).not_to eq(subject.new(a: 1, b: 3))
    end
  end

  describe Redd::Options::ClientOptions do
    describe '#initialize' do
      context 'when user_agent is not provided' do
        it 'uses the default user_agent' do
          instance = Redd::Options::ClientOptions.new
          expect(instance.user_agent)
            .to eq(Redd::Options::ClientOptions::DEFAULT_USER_AGENT)
        end
      end
    end
  end

  describe Redd::Options::AuthorizationOptions do
    describe '#initialize' do
      context 'when user_agent is not provided' do
        it 'uses the default user_agent' do
          instance = Redd::Options::AuthorizationOptions.new
          expect(instance.endpoint)
            .to eq(Redd::Options::AuthorizationOptions::DEFAULT_AUTH_ENDPOINT)
        end
      end
    end

    describe '#inspect' do
      it 'does not print out sensitive information' do
        instance = Redd::Options::AuthorizationOptions.new do |options|
          options.client_id = 'CLIENT_ID'
          options.secret    = 'SECRET'
          options.username  = 'USERNAME'
          options.password  = 'PASSWORD'
        end
        expect(instance.inspect).not_to include('SECRET')
        expect(instance.inspect).not_to include('PASSWORD')
      end
    end
  end

  describe Redd::Options::APIOptions do
    describe '#initialize' do
      context 'when access is not provided' do
        it 'raises an error' do
          expect { Redd::Options::APIOptions.new }
            .to raise_error('`access` must be provided!')
        end
      end

      context 'when endpoint is not provided' do
        it 'uses the default endpoint' do
          instance = Redd::Options::APIOptions.new(access: double('Access'))
          expect(instance.endpoint)
            .to eq(Redd::Options::APIOptions::DEFAULT_API_ENDPOINT)
        end
      end
    end
  end
end
