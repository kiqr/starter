module Kiqr
  module Cli
    module Extensions
      class Commands < Thor
        include Thor::Actions

        def self.exit_on_failure?
          true
        end

        desc "test_app", "Generate a dummy application for testing"
        def test_app
          require "kiqr/cli/extensions/generators/dummy/dummy_generator"
          Kiqr::Cli::Extensions::Generators::DummyGenerator.start
        end
      end
    end
  end
end
