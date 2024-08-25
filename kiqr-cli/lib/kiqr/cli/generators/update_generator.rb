require "pathname"
require "rails/generators"

module Kiqr
  module Cli
    module Generators
      class UpdateGenerator < Rails::Generators::Base
        source_paths << Kiqr::Engine.root

        def copy_migrations
          say_status :copying, "migrations"
          rake "kiqr:install:migrations"
        end

        def copy_models
          say_status :copying, "models"
          source = File.join(Kiqr::Engine.root, "app/models")
          destination = File.join(Rails.root, "app/models")

          safe_directory source, destination
        end

        protected

        def safe_directory(source, destination)
          Dir.glob(File.join(source, "**", "*")).each do |file|
            # Calculate the destination path
            dest_file = file.sub(source, destination)

            if File.directory?(file)
              # Create the directory if it doesn't exist
              FileUtils.mkdir_p(dest_file) unless File.exists?(dest_file)
            else
              # Skip if file already exists
              if File.exist?(dest_file)
                say_status :exist, dest_file, :blue
              else
                # Copy the file
                say_status :create, dest_file
                FileUtils.cp(file, dest_file)
              end
            end
          end
        end
      end
    end
  end
end
