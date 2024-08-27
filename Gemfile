# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake"

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false

  # This gem is used in Railties tests so it must be a development dependency.
  gem "rubocop-rails-omakase", require: false
end
