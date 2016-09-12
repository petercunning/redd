# frozen_string_literal: true

require 'redd/model'

describe Redd::Model do
  let(:attributes) { { foo: 'bar', one: 1 } }
  subject { model(Redd::Model, attributes) }

  describe '#initialize' do
    context 'when no attributes are provided' do
      it 'creates an empty model' do
        empty_model = model(Redd::Model)
        expect(empty_model.attributes).to eq({})
      end
    end

    context 'when some attributes are provided' do
      it 'has the same attributes it was created with' do
        expect(subject.attributes).to eq(attributes)
      end
    end
  end

  describe '#attributes' do
    it 'returns the models attributes' do
      expect(subject.attributes).to eq(attributes)
    end
  end

  describe '#attribute?' do
    context 'when the attribute exists' do
      it 'returns true' do
        expect(subject.attribute?(:foo)).to be true
        expect(subject.attribute?(:one)).to be true
      end
    end

    context 'when the attribute does not exist' do
      it 'returns false' do
        expect(subject.attribute?(:bar)).to be false
      end
    end
  end

  describe '#respond_to?' do
    context 'when the attribute exists' do
      it 'returns true for respond_to?' do
        expect(subject).to respond_to(:foo)
        expect(subject).to respond_to(:one)
      end
    end

    context 'when the attribute does not exist' do
      it 'returns false for respond_to?' do
        expect(subject).not_to respond_to(:bar)
      end
    end
  end

  describe '#method_missing' do
    context 'when the attribute exists' do
      it 'returns the attribute' do
        expect(subject.foo).to eq(attributes[:foo])
        expect(subject.one).to eq(attributes[:one])
      end
    end

    context 'when the attribute does not exist' do
      it 'raises a NoMethodError' do
        expect { subject.bar }.to raise_error(NoMethodError)
      end
    end
  end
end
