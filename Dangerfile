# Dangerfile

# =>  Prevent specific files from being committed
forbidden_files = [
  "config/credentials.yml.enc"
]

(git.modified_files + git.added_files).each do |file|
  if forbidden_files.include?(file)
    fail("#{file} should not be committed.")
  end
end

# => Check for a description on the PR
if github.pr_body.length < 10
  fail("Please provide a description of the changes in this PR.")
end

# => Encourage contributors to add or update tests for new features or bug fixes.
modified_test_files = git.modified_files.grep(%r{^test/})
relevant_code_changes = git.modified_files.grep(%r{^app/|^lib/})

if relevant_code_changes.any? && modified_test_files.empty?
  warn("It looks like you haven't added or updated any tests. Please make sure you include tests for your changes.")
end

# => Warn for updated dependencies
if git.modified_files.include?("Gemfile.lock")
  warn("You have updated dependencies. Please justify these changes in the PR description.")
end

# => Check for conventional commits
# https://www.conventionalcommits.org/en/v1.0.0/

conventional_commit_regex = /\A(feat|fix|docs|style|refactor|perf|test|chore|build|ci)(\(.+\))?: .+/
# Check PR title for conventional commits
unless conventional_commit_regex.match(github.pr_title)
  fail("Please use conventional commits for your PR title.")
end

# Fail the build if there's more than one commit
if git.commits.length > 1
  fail("This pull request contains more than one commit. Please squash your commits into a single commit.")
end

# Check each commit message for conventional commits
git.commits.each do |commit|
  unless conventional_commit_regex.match(commit.message)
    fail("Commit message '#{commit.message}' does not follow the Conventional Commits standard. Please reformat it.")
  end
end
