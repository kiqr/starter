require "thor"

module Kiqr
  module Cli
    class Commands < Thor
      include Thor::Actions

      # This is a Thor class method that will be called when an error occurs.
      def self.exit_on_failure?
        true
      end

      # KIQR provides the update command. After updating the KIQR version
      # in the Gemfile, run this command. This will help you with the creation of new
      # files and changes of old files in an interactive session.
      desc "update", "Update configs and some other initially generated files for KIQR"
      def update
        require "kiqr/cli/generators/update_generator"
        Kiqr::Cli::Generators::UpdateGenerator.start
      end

      desc "version", "Prints the KIQR version information"
      def version
        say Kiqr.config.app_name
        say Gem.loaded_specs["kiqr-cli"].version
      end
    end
  end
end

Kiqr::Cli::Commands.start(ARGV)
