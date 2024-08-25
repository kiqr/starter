require "thor"

module Kiqr
  module Cli
    class AppGenerator < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "create", "Create a new KIQR application."
      def create
        say "Welcome to KIQR! Let's get started with the installation process."
      end
    end
  end
end

Kiqr::Cli::AppGenerator.start(ARGV)
