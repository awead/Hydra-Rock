namespace :rockhall do

  namespace :dev do

    desc "Setup solr and fedora"
    task :setup do
      Rake::Task["rockhall:jetty:config"].invoke
      Rake::Task["jetty:start"].invoke
      Rake::Task["rockhall:fedora:load"].invoke
    end

    desc "Prepare devlopment environment"
    task :prep => :environment do
      Rake::Task["db:drop"].invoke
      Rake::Task["db:migrate"].invoke
      ActiveRecord::Tasks::DatabaseTasks.fixtures_path = 'spec/fixtures/ar/'
      Rake::Task["db:fixtures:load"].invoke
      Rake::Task["rockhall:solr:clean"].invoke
      Rake::Task["rockhall:solr:index_all"].invoke
    end

    desc "Prepare test environment"
    task :test_prep do
      `bundle exec rake rockhall:dev:prep RAILS_ENV=test`
    end

  end
end