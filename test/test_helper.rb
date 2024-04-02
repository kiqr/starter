ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start "rails" do
  add_filter %r{^/test/}
end

require_relative "../config/environment"
require "rails/test_help"

# Load migrations
ActiveRecord::Schema.verbose = false

def fill_in_account_fields
  fill_in "account[name]", with: "New name"
end

module ActiveSupport
  class TestCase
    include Devise::Test::IntegrationHelpers
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
