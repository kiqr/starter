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
  end
end
