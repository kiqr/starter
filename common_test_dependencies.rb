source "https://rubygems.org"

group :development, :test do
  gem "rails", "~> 7.2.1"
  gem "sqlite3", ">= 1.4"
  gem "sprockets-rails"
  gem "bootsnap", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "factory_bot", "~> 6.4.3"
  gem "faraday-retry"
  gem "faraday-multipart"
  gem "faker"
  gem "rails-controller-testing"
end

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false
  gem "rubocop-rails-omakase", require: false
end
