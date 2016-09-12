# frozen_string_literal: true

require 'redd/version'

describe 'Redd::VERSION' do
  it 'is a string' do
    expect(Redd::VERSION).to be_a(String)
  end
end
