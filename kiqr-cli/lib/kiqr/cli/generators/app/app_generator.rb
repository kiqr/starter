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
          if kiqr_core_directory = find_upwards("KIQR_VERSION")
            version_tag = "path: \"#{kiqr_core_directory}\""
          else
            version_tag = "\"~> #{Kiqr.version}\""
          end

          gemfile_additions = <<~EOS
          # KIQR Framework [https://github.com/kiqr/kiqr]
          gem "kiqr", #{version_tag}

          # View components and design system by KIQR [https://github.com/kiqr/irelia]
          gem "irelia", git: "https://github.com/kiqr/irelia.git", branch: "main"
          EOS
          append_file File.expand_path("Gemfile", app_path), gemfile_additions, after: /gem "rails", ".*"/
        end

        def overried
          directory "rails", app_path, force: true
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

          gsub_file File.expand_path("config/routes.rb", app_path), /\# root "posts#index"/ do
            routes_addition.strip
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

        # Allows wildcard search for file name.
        def find_upwards(file)
          current_path = Dir.pwd
          while current_path != "/"
            if Dir.glob(File.join(current_path, file)).any?
              return current_path
            else
              current_path = File.expand_path(File.join(current_path, ".."))
            end
          end
        end
      end
    end
  end
end
