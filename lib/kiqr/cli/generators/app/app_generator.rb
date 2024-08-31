require "rails/generators/rails/app/app_generator"
require "fileutils"

module Kiqr
  module Cli
    module Generators
      class AppGenerator < Rails::Generators::Base
        source_paths << File.expand_path("templates", __dir__)
        argument :app_name, type: :string, default: "test_app"

        PASSTHROUGH_OPTIONS = %w[
          ruby template skip_gemfile skip_bootsnap skip_bundle skip_git skip_keeps skip_active_record skip_sprockets
          skip_spring database javascript skip_javascript dev edge skip_turbolinks skip_test_unit rc
          no_rc force pretend quiet skip help version skip_decrypted_diffs
        ]

        # Temporary set BUNDLE_GEMFILE to the path of the Gemfile in the root of the application
        def set_bundle_gemfile
          @original_gemfile = ENV["BUNDLE_GEMFILE"]
          ENV["BUNDLE_GEMFILE"] = File.join(app_path, "Gemfile")
        end

        def generate_rails_application
          say "Generating Rails application..."
          opts = {}.merge(options).slice(*PASSTHROUGH_OPTIONS)
          invoke Rails::Generators::AppGenerator, [ app_path ], opts
        end

        def add_kiqr_gem
          if kiqr_core_directory = find_upwards("kiqr.gemspec")
            version_tag = "path: \"#{kiqr_core_directory}\""
          else
            version_tag = "\"~> #{Kiqr.version}\""
          end

          gemfile_additions = <<~EOS
          \n
          # KIQR Framework [https://github.com/kiqr/kiqr]
          gem "kiqr", #{version_tag}

          # View components and design system by KIQR [https://github.com/kiqr/irelia]
          gem "irelia", git: "https://github.com/kiqr/irelia.git", branch: "main"
          EOS
          append_file File.expand_path("Gemfile", app_path), gemfile_additions, after: /gem "rails", ".*"/
        end

        def add_test_gems
          gemfile_additions = <<~EOS
          \n
            gem "factory_bot", "~> 6.4.3"
            gem "faraday-retry"
            gem "faraday-multipart"
            gem "faker"
            gem "rails-controller-testing"
EOS
          append_file File.expand_path("Gemfile", app_path), gemfile_additions, after: /gem "selenium-webdriver"/
        end

        def run_kiqr_update_generator
          return if options[:skip_bundle]

          inside app_path do
            run "bundle install"
            run "bundle exec rails generate kiqr:install"
            run "bundle exec rails generate kiqr:update"
            run "bundle exec rails generate kiqr:themes:irelia:install"
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
