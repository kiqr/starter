source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sqlite3", ">= 1.4"
gem "sprockets-rails"

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false
  gem "rubocop-rails-omakase", require: false
end
