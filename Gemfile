# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in redd.gemspec
gemspec

# Only install Coveralls when testing. Travis runs "bundle install" on every
# run, so this gem will be included.
group :test do
  gem 'coveralls', require: false
end
