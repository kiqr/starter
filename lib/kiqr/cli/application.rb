require "kiqr"

module Kiqr
  module Cli
    class Application < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "new [app_name]", "Create a new KIQR application"
      def new(app_name)
        invoke Kiqr::Cli::Generators::AppGenerator, [ app_name ]
      end

      desc "extensions", "Create or manage extensions"
      subcommand "extensions", Kiqr::Cli::Extensions

      desc "version", "Show KIQR CLI version"
      def version
        say Gem.loaded_specs["kiqr"].version
      end
    end
  end
end
