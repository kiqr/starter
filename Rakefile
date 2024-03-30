# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks
Rake::Task["default"].clear

namespace :lint do
  task :standard do
    sh "bundle exec standardrb"
  end

  task :erb do
    sh "bundle exec erblint --lint-all"
  end
end

task :default do
  Rake::Task["test"].invoke
  Rake::Task["test:system"].invoke
  Rake::Task["lint:standard"].invoke
  Rake::Task["lint:erb"].invoke
end
