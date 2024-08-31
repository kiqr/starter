require "rails"
require "thor"
require "pathname"

module Kiqr
  module Cli
    autoload :Application, "kiqr/cli/application"
    autoload :Extensions, "kiqr/cli/extensions"

    module Generators
      autoload :AppGenerator, "kiqr/cli/generators/app/app_generator"
      autoload :DummyGenerator, "kiqr/cli/generators/dummy/dummy_generator"
    end

    class << self
      def run
        exec_app || Kiqr::Cli::Application.start(ARGV)
      end

      def exec_app
        original_cwd = Dir.pwd
        ruby_exe = Gem.ruby

        loop do
          if exe = File.file?("bin/kiqr")
            exec ruby_exe, "bin/kiqr", *ARGV
            break # non reachable, hack to be able to stub exec in the test suite
          end

          # If we exhaust the search there is no executable, this could be a
          # call to generate a new application, so restore the original cwd.
          Dir.chdir(original_cwd) && return if Pathname.new(Dir.pwd).root?

          # Otherwise keep moving upwards in search of an executable.
          Dir.chdir("..")
        end
      end
    end
  end
end
