# List of files to delete from your new repository
files_or_folders_to_delete = [
  "Dangerfile",
  ".github/workflows/dangerfile.yml"
]

# => Remove KIQR development files
files_or_folders_to_delete.each do |file_or_folder|
  run_command("rm -rf #{file_or_folder}")
  say "✅  Removed #{file_or_folder}"
end

# => Update .gitignore file
# Read the contents of the .gitignore file
gitignore_content = File.read(".gitignore")

# Use a regular expression to remove everything between "# => KIQR START" and "# => KIQR END"
cleaned_content = gitignore_content.gsub(/# => KIQR START[\s\S]*?# KIQR END\n?/, '')

# Write the cleaned content back to the .gitignore file
File.open(".gitignore", 'w') { |file| file.write(cleaned_content) }
say "✅  Cleaned up .gitignore"

# => Replace README.md with README.md.example
run_command("mv README.md.example README.md")
if File.exist?("README.md.example")
  say "✅  Replaced README.md with README.md.example"
else
  say "✅  README.md file has already been replaced"
end
