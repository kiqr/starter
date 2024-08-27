require "thor"
require "awesome_print"

module Kiqr
  class Commands < Thor
    include Thor::Actions

    # This is a Thor class method that will be called when an error occurs.
    def self.exit_on_failure?
      true
    end

    desc "config", "Inspect KIQR configurations values"
    def config
      say "KIQR Configuration:\n\n"
      ap Kiqr::Config.config.stringify_keys, indent: -2
    end

    # KIQR provides the update command. After updating the KIQR version
    # in the Gemfile, run this command. This will help you with the creation of new
    # files and changes of old files in an interactive session.
    desc "update", "Update configs and some other initially generated files for KIQR"
    def update
      require "generators/kiqr/update/update_generator"
      Kiqr::UpdateGenerator.start
    end

    desc "version", "Prints the KIQR version information"
    def version
      say Gem.loaded_specs["kiqr-cli"].version
    end
  end
end

Kiqr::Commands.start(ARGV)
