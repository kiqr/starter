require "rails/generators/rails/app/app_generator"
require "fileutils"

module Kiqr
  module Cli
    module Generators
      class DummyGenerator < Rails::Generators::Base
        source_paths << File.expand_path("templates", __dir__)

        def clean_up_dummy_directory
          remove_dir(dummy_path)
        end

        def generate_dummy_application
          say "Generating dummy application..."
          invoke Rails::Generators::AppGenerator, [ dummy_path ], {
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
            remove_dir ".github"
            remove_file ".gitignore"
            remove_file ".rubocop"
            remove_file ".ruby-version"
            remove_file "Dockerfile"
            remove_file "doc"
            # remove_file "Gemfile"
            remove_file "lib/tasks"
            remove_file "app/assets/images/rails.png"
            remove_file "app/assets/javascripts/application.js"
            remove_file "public/index.html"
            remove_file "public/robots.txt"
            remove_file "README"
            remove_file "test"
            remove_file "vendor"
            remove_file "spec"
          end
        end

        def replace_files
          template "application.rb", "#{dummy_path}/config/application.rb", force: true
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
