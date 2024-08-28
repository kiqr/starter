require "rails/generators/rails/app/app_generator"
require "fileutils"

module Kiqr
  module Cli
    module Generators
      class AppGenerator < Rails::Generators::Base
        source_paths << File.expand_path("templates", __dir__)
        argument :app_name, type: :string, default: "test_app"

        PASSTHROUGH_OPTIONS = %w[
          ruby template skip_gemfile skip_bundle skip_git skip_keeps skip_active_record skip_sprockets
          skip_spring database javascript skip_javascript dev edge skip_turbolinks skip_test_unit rc
          no_rc force pretend quiet skip help version skip_decrypted_diffs
        ]

        def prepare_gemfile_env
          @original_gemfile = ENV["BUNDLE_GEMFILE"]
          ENV["BUNDLE_GEMFILE"] = File.join(app_path, "Gemfile")
        end

        def generate_rails_application
          say "Generating Rails application..."
          opts = {}.merge(options).slice(*PASSTHROUGH_OPTIONS)
          invoke Rails::Generators::AppGenerator, [ app_path ], opts
        end

        def add_kiqr_gem
          append_file File.expand_path("Gemfile", app_path), %(\n# KIQR framework [https://github.com/kiqr/kiqr]\ngem "kiqr", "~> #{Kiqr.version}"), after: /gem "rails", ".*"/
        end

        def copy_development_credentials
          directory "config/credentials", File.expand_path("config/credentials", app_path)
        end

        def copy_layout_files
          directory "views/layouts", File.expand_path("app/views/layouts", app_path)
        end

        def write_kiqr_routes_to_routes_file
          kiqr_routes = <<~EOS
          root "public#welcome"

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

          gsub_file File.expand_path("config/routes.rb", app_path), /\# root "posts#index"/ do
            kiqr_routes.strip
          end
        end

        def run_kiqr_update_generator
          say_status(:skip, "kiqr:update", :yellow) && return if options[:skip_bundle]
          inside app_path do
            run "bundle exec rails generate kiqr:update"
          end
        end

        def reset_gemfile_env
          ENV["BUNDLE_GEMFILE"] = @original_gemfile
        end

        protected

        def app_path
          File.expand_path(app_name, destination_root)
        end
      end
    end
  end
end
