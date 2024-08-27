module Kiqr
  module Cli
    class Extensions < Thor
      # def self.banner(command, namespace = nil, subcommand = false)
      #   "#{basename} #{subcommand_prefix} #{command.usage}"
      # end

      # def self.subcommand_prefix
      #   self.name.gsub(%r{.*::}, "").gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
      # end

      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "test_app", "Generate a dummy application for testing"
      def test_app
        say "Generating a dummy application..."
      end
    end
  end
end
