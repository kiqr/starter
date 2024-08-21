require "highline"
require "highline/import"
require "colorize"

def fail_with_message(message)
  say message.red
  exit(1)
end

# => Run system commands and check for success
def run_command(command)
  success = system(command)
  fail_with_message "Error: Command failed - #{command}" unless success
end

# => Check for uncommitted changes
def check_for_uncommited_changes
  # => Check for uncommitted changes
  say "🔍  Checking for uncommitted changes..."
  uncommitted_changes = !`git status --porcelain`.strip.empty?

  if uncommitted_changes
    say "🚨  You have uncommitted changes. Please commit or stash them before proceeding."
    exit(1)
  else
    say "✅  No uncommitted changes found."
  end
end
