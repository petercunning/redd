# frozen_string_literal: true

require 'redd/access'

describe Redd::Access do
  describe '#refreshable?' do
    context 'when the refresh token is present' do
      it 'is refreshable' do
        access = model(Redd::Access, refresh_token: 'bar')
        expect(access).to be_refreshable
      end
    end

    context 'when the refresh token is absent' do
      it 'is not refreshable' do
        access = model(Redd::Access)
        expect(access).not_to be_refreshable
      end
    end
  end

  describe '#created_at' do
    it 'returns the time the Access was initialized' do
      access = model(Redd::Access)
      expect(access.created_at).to be_within(0.1).of(Time.now)
    end
  end

  describe '#expires_at' do
    it 'returns the expiration time' do
      access = model(Redd::Access, expires_in: 3600)
      expect(access.expires_at).to be_within(0.1).of(Time.now + 3600)
    end
  end

  describe '#expired?' do
    context 'when the current time is before expiry' do
      it 'returns false' do
        access = model(Redd::Access, expires_in: 3600)
        expect(access).to_not be_expired
      end
    end

    context 'when the current time is in the grace period (5 minutes)' do
      context 'when grace_period is true (default)' do
        it 'returns true' do
          access = model(Redd::Access, expires_in: 3600)
          expiry_time = Time.now + 3596
          allow(Time).to receive(:now).and_return(expiry_time)

          expect(access).to be_expired
        end
      end

      context 'when grace_period is false' do
        it 'returns false' do
          access = model(Redd::Access, expires_in: 3600)
          expiry_time = Time.now + 3596
          allow(Time).to receive(:now).and_return(expiry_time)

          expect(access).not_to be_expired(false)
        end
      end
    end

    context 'when the current time is way after expiry' do
      it 'returns true' do
        access = model(Redd::Access, expires_in: 3600)
        expiry_time = Time.now + 4800

        allow(Time).to receive(:now).and_return(expiry_time)
        expect(access).to be_expired
      end
    end
  end

  describe '#scope?' do
    context 'when the user has all scopes (*)' do
      it 'returns true for all values' do
        access = model(Redd::Access, scope: '*')
        # Using non-existent scope to ensure failure if/when we implement
        # checking scopes against a list of valid scopes.
        expect(access.scope?(:asdf)).to be true
        expect(access.scope?(:identity)).to be true
        expect(access.scope?(:read)).to be true
      end
    end

    context 'when the user has some scopes' do
      subject { model(Redd::Access, scope: 'identity,vote') }
      it 'returns true for the scopes that were provided' do
        expect(subject.scope?(:identity)).to be true
        expect(subject.scope?(:vote)).to be true
      end

      it 'returns false for the scopes that were not provided' do
        # Using non-existent scope to ensure failure if/when we implement
        # checking scopes against a list of valid scopes.
        expect(subject.scope?(:asdf)).to be false
        expect(subject.scope?(:read)).to be false
      end
    end
  end
end
