require "rails/generators/base"

module Kiqr
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    # Copy migrations to host application.
    def copy_migrations
      say "Copying migrations to host app..", :green
      rake "kiqr_engine:install:migrations"
    end
  end
end
