require "highline"
require "highline/import"
require "colorize"

def fail_with_message(message)
  say message.red
  exit(1)
end

# Run system commands and check for success
def run_command(command)
  success = system(command)
  fail_with_message "Error: Command failed - #{command}" unless success
end
