source "https://rubygems.org"

gemspec

group :development, :test do
  gem "rails", "~> 7.2.1"
  gem "sqlite3", ">= 1.4"
  gem "sprockets-rails"
  gem "bootsnap", require: false
  gem "puma", ">= 5.0"

  # View components and design system by KIQR [https://github.com/kiqr/irelia]
  gem "irelia", git: "https://github.com/kiqr/irelia.git", branch: "main"
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
