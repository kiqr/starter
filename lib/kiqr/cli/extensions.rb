module Kiqr
  module Cli
    class Extensions < Thor
      include Thor::Actions

      def self.exit_on_failure?
        true
      end
    end
  end
end
