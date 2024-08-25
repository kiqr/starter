require "kiqr/cli/app_loader"

# If we are inside a KIQR application this method performs an exec and thus
# the rest of this script is not run.
Kiqr::Cli::AppLoader.exec_app

# If we are not inside a KIQR application, we require the commands and start the CLI.
# require "kiqr/cli/installer"

case ARGV.first
when "version", "-v", "--version"
  puts Gem.loaded_specs["kiqr-cli"].version
# when "extension"
#   ARGV.shift
#   require "kiqr/cli/extension"
#   Kiqr::Extension.start
else
  require "kiqr/cli/app_generator"
end
