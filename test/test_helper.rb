# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start do
  add_filter %r{^/test/}
  add_filter "lib/kiqr/version.rb"

  add_group "Models", "app/models"
  add_group "Services", "lib/kiqr/services"
end

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../db/migrate", __dir__) ]
require "rails/test_help"

FactoryBot.find_definitions

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
