#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)

HydraRock::Application.load_tasks

desc "Run continuous integration build"
task :ci do
  Rake::Task["rockhall:dev:setup"].invoke
  Rake::Task["rockhall:dev:test_prep"].invoke
  Rake::Task["spec"].invoke
end

Rake::Task[:default].prerequisites.clear
task :default => [:ci]
