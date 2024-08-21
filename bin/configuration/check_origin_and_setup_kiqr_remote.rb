# Get the upstream repository URL.
origin_url = `git remote get-url origin`.strip
origin_exists = system('git remote get-url origin > /dev/null 2>&1')
kiqr_remote_exists = system('git remote get-url kiqr  > /dev/null 2>&1')
origin_is_kiqr = origin_exists && origin_url.include?("kiqr/kiqr")
kiqr_remote_url = "git@github.com:kiqr/kiqr.git"

say "🔍  Checking for the 'origin' remote..."

# Check if origin is kiqr/kiqr
if origin_is_kiqr
  fail_with_message <<~WARNING

  WARNING: It looks like your 'origin' remote is set to 'github.com/kiqr/kiqr'.

  This suggests that you may have cloned the project directly instead of using the GitHub 'Use this template' function.

  🚨 Running the configure command might break your development environment by renaming branches or remotes in a way that could disrupt the original repository.

  👉 To avoid this, it's strongly recommended to use the GitHub template feature to create a new repository based on this project.

  You can do this by going to the project's GitHub page and clicking the 'Use this template' button.
  This will ensure you have your own independent repository with its own 'origin' remote.

  If you proceed with the configure command, please be aware of the potential risks.
  WARNING
end

# # Check if origin is not set
unless origin_exists
  fail_with_message <<~WARNING

    ⚠️  WARNING: It looks like your repository does not have an 'origin' remote configured.

    This suggests that you may have set up this project incorrectly or did not use the GitHub 'Use this template' function.

    🚨 Without an 'origin' remote, you won't be able to push your changes to a remote repository or properly manage the upstream connection.

    👉 To correctly set up your repository, it's strongly recommended to use the GitHub template feature to create a new repository based on this project.

    You can do this by going to the project's GitHub page and clicking the 'Use this template' button.
    This will create a new repository with the correct 'origin' remote configured, allowing you to push changes and track your own repository history.

    If you proceed with the configure command, please be aware that you may encounter issues with managing your repository.
    Press Ctrl+C to cancel now if you do not want to proceed.
  WARNING
end


say "✅  The 'origin' remote is correctly configured."
say "🔍  Checking for the 'kiqr' remote..."

if kiqr_remote_exists
  say "✅  The 'kiqr' remote already exists."
else
  say "🚨  The 'kiqr' remote does not exist. Adding it now..."
  run_command("git remote add kiqr #{kiqr_remote_url}")
  say "✅  The 'kiqr' remote has been added."
end
