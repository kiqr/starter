require "rails/generators/rails/app/app_generator"
require "fileutils"

module Kiqr
  module Cli
    module Generators
      class DummyGenerator < Rails::Generators::Base
        source_paths << File.expand_path("templates", __dir__)

        CLEANUP_FILES = %w[
          .dockerignore
          .github
          .gitignore
          .rubocop.yml
          .ruby-version
          Dockerfile
          Gemfile
          lib/tasks
          test
        ]

        def clean_up_dummy_directory
          remove_dir(dummy_path)
        end

        def generate_dummy_application
          say "Generating dummy application..."
          invoke Kiqr::Cli::Generators::AppGenerator, [ dummy_path ], {
            force: true,
            skip_bundle: true,
            skip_git: true,
            skip_decrypted_diffs: true,
            skip_listen: true,
            skip_rc: true,
            skip_spring: true,
            skip_test: true,
            skip_bootsnap: true,
            minimal: true
          }
        end

        def cleanup_unnessary_files
          inside dummy_path do
            CLEANUP_FILES.each do |file|
              remove_file file
            end
          end
        end

        def install_kiqr
          inside dummy_path do
            run "bundle exec rails generate kiqr:update"
          end
        end

        protected

        def dummy_path
          @dummy_path ||= File.join(extension_root_dir, "test/dummy")
        end

        # Recursively search for the folder containing the gemspec file.
        def extension_root_dir
          find_upwards("*.gemspec")
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
