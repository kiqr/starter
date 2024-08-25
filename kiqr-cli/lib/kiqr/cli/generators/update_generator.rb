require "rails/generators"

module Kiqr
  module Cli
    module Generators
      class UpdateGenerator < Rails::Generators::Base
        def copy_migrations
          say_status :copying, "migrations"
          rake "kiqr:install:migrations"
        end
      end
    end
  end
end
