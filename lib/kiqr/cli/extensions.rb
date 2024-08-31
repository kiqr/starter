module Kiqr
  module Cli
    class Extensions < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end

      desc "test_app", "Create a dummy app for testing"
      def test_app
        Kiqr::Cli::Generators::DummyGenerator.start
      end
    end
  end
end
