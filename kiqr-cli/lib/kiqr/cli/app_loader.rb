require "pathname"

module Kiqr
  module Cli
    module AppLoader
      extend self

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
