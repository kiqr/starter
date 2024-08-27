require "rails/generators/rails/app/app_generator"
require "fileutils"

module Kiqr
  module Cli
    module Extensions
      module Generators
        class AppGenerator < Rails::Generators::Base
          source_paths << File.expand_path("templates", __dir__)
          argument :app_name, type: :string, default: "test_app"

          PASSTHROUGH_OPTIONS = %w[
            force
          ]

          def prepare_gemfile_env
            ENV["BUNDLE_GEMFILE"] = File.join(app_path, "Gemfile")
          end

          def generate_dummy_application
            say "Generating Rails application..."
            opts = {}.merge(options).slice(*PASSTHROUGH_OPTIONS)
            # opts[:skip_bundle] = true

            invoke Rails::Generators::AppGenerator, [ app_path ], opts
          end

          protected

          def app_path
            File.expand_path(app_name, destination_root)
          end
        end
      end
    end
  end
end
