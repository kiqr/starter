module Kiqr
  module Cli
    class Application < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "extensions", "Create or manage extensions"
      subcommand "extensions", Kiqr::Cli::Extensions

      desc "version", "Show KIQR CLI version"
      def version
        say Gem.loaded_specs["kiqr-cli"].version
      end
    end
  end
end
