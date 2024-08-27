require "kiqr"

module Kiqr
  module Cli
    class Application < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "new", "Create a new KIQR application"
      argument :app_name, type: :string, required: true, desc: "The name of the new application"
      def new
        puts "Argument directory: #{app_name}"
        require "kiqr/cli/extensions/generators/app/app_generator"
        invoke Kiqr::Cli::Extensions::Generators::AppGenerator, [app_name]
      end

      desc "extensions", "Create or manage extensions"
      subcommand "extensions", Kiqr::Cli::Extensions::Commands

      desc "version", "Show KIQR CLI version"
      def version
        say Gem.loaded_specs["kiqr-cli"].version
      end
    end
  end
end
