namespace :rockhall do

  namespace :dev do

    desc "Run the entire application setup process"
    task :setup do
      Rake::Task["rockhall:jetty:config"].invoke
      Rake::Task["jetty:start"].invoke
      Rake::Task["rockhall:fedora:load"].invoke
      ENV["FIXTURES_PATH"] = "spec/fixtures/ar/activities.yml"
      Rake::Task["db:fixtures:load"].invoke
      Rake::Task["db:fixtures:load"].reenable
      ENV["FIXTURES_PATH"] = "spec/fixtures/ar/users.yml"
      Rake::Task["db:fixtures:load"].invoke
      Rake::Task["rockhall:solr:index_all"].invoke
      Rake::Task["rockhall:solr:index_all"].reenable
      Rake::Task["rockhall:solr:index_all"].invoke
    end

    desc "Prepare solr to run spec tests"
    task :test_prep do
      #`bundle exec rake db:migrate RAILS_ENV=test`
      `bundle exec rake db:fixtures:load FIXTURES_PATH=spec/fixtures/ar/activities.yml RAILS_ENV=test`
      `bundle exec rake db:fixtures:load FIXTURES_PATH=spec/fixtures/ar/users.yml RAILS_ENV=test`
      `bundle exec rake rockhall:solr:index_all RAILS_ENV=test`
    end

  end
end