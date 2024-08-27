require "kiqr/cli/version"
require "thor"

module Kiqr
  module Cli
    autoload :Application, "kiqr/cli/application"

    module Extensions
      autoload :Commands, "kiqr/cli/extensions/commands"
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
