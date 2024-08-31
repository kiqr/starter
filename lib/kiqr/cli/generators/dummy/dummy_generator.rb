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
          Gemfile
          Gemfile.lock
          Dockerfile
          lib/tasks
          test
        ]

        def clean_up_dummy_directory
          say "Cleaning up dummy directory: #{dummy_path}"
          remove_dir dummy_path
        end

        def create_dummy_app
          opts = {
            skip_bundle: true,
            skip_git: true,
            skip_decrypted_diffs: true,
            skip_listen: true,
            skip_rc: true,
            skip_spring: true,
            skip_test: true,
            skip_bootsnap: true
          }

          say "Generating dummy Rails application at #{dummy_path}"
          invoke Rails::Generators::AppGenerator, [ dummy_path ], opts
        end

        def cleanup_unnessary_files
          inside dummy_path do
            CLEANUP_FILES.each do |file|
              remove_file file
            end
          end
        end

        def replace_boot_file
          directory "rails", File.join(dummy_path), force: true
        end

        def install_frontend_dependencies
          inside dummy_path do
            run "bundle install --quiet"
            run "bin/rails importmap:install"
            run "bin/rails stimulus:install"
          end
        end

        def install_turbo
          append_to_file File.join(dummy_path, "app/javascript/application.js"), %(import "@hotwired/turbo-rails"\n)
          append_to_file File.join(dummy_path, "config/importmap.rb"), %(pin "@hotwired/turbo-rails", to: "turbo.min.js"\n)
        end

        private

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
