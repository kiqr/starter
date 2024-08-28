# Configure Rails Environment
ENV["RAILS_ENV"] ||= "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
require "rails/test_help"

ActiveRecord::Migration.maintain_test_schema!

FactoryBot.find_definitions
I18n.available_locales = %w[en sv]

module ActiveSupport
  class TestCase
    include Devise::Test::IntegrationHelpers
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end
