#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

HydraRock::Application.load_tasks

desc "Run continuous integration build"
task :ci do
  Rake::Task["db:migrate"].invoke
  Rake::Task["rockhall:dev:setup"].invoke
  Rake::Task["rockhall:dev:test_prep"].invoke
  Rake::Task["spec"].invoke
end

Rake::Task[:default].prerequisites.clear
task :default => [:ci]

