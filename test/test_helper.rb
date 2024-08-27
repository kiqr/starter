ENV["RAILS_ENV"] ||= "test"

require_relative "../starter/config/environment"
require "rails/test_help"

FactoryBot.find_definitions
I18n.available_locales = %w[en sv]

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
