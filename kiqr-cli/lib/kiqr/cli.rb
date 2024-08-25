require "thor"

case ARGV.first
when "version", "-v", "--version"
  puts Gem.loaded_specs["kiqr-cli"].version
# when "extension"
#   ARGV.shift
#   require "kiqr/cli/extension"
#   SpreeCli::Extension.start
else
  require "kiqr/cli/commands"
  Kiqr::Cli::Commands.start
end
