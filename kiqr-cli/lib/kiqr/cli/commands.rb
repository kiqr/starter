module Kiqr
  module Cli
    class Commands < Thor
      include Thor::Actions

      # KIQR provides the update command. After updating the KIQR version
      # in the Gemfile, run this command. This will help you with the creation of new
      # files and changes of old files in an interactive session.
      desc "update", "Update configs and some other initially generated files for KIQR"
      def update
        require "kiqr/cli/generators/update_generator"
        Kiqr::Cli::Generators::UpdateGenerator.start
      end
    end
  end
end
