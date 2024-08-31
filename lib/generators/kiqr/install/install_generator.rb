require "pathname"
require "rails/generators"

module Kiqr
  class InstallGenerator < Rails::Generators::Base
    source_paths << File.expand_path("templates", __dir__)

    def welcome_message
      say "Installing KIQR..", :green
    end

    def override_app_files
      directory "rails", Rails.root, force: true
    end

    def write_kiqr_routes_to_routes_file
      routes_addition = <<~EOS
      root "public#landing_page"

        # => KIQR core routes
        # These routes are required for the KIQR core to function properly.
        # Refer to the KIQR documentation for more information on how
        # to customize these routes or override controllers.
        kiqr_routes

        # Routes inside this block will be prefixed with /team/<team_id> if
        # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
        #
        # Example:
        # /team/:team_id/dashboard <- if user is signed in to a team account
        # /dashboard <- if user is browsing the app without a team account
        #
        account_scope do
          get "dashboard", to: "dashboard#show"
        end
      EOS

      gsub_file File.expand_path("config/routes.rb", Rails.root), /\# root "posts#index"/ do
        routes_addition.strip
      end
    end
  end
end
