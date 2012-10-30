namespace :rockhall do

    desc "Export items from hydra into blacklight"
    task :discovery => :environment do
      Rockhall::Discovery.delete_objects
      Rockhall::Discovery.update
    end

    desc "Delete everything from Fedora and reindex our fixtures in both development and test"
    task :reload_fixtures => :environment do

      # Re-sync solr development
      ENV["RAILS_ENV"] = "development"
      Rake::Task["hydra:jetty:solr_clean"].invoke
      Rake::Task["hydra:jetty:solr_clean"].reenable
      ENV["RAILS_ENV"] = "development"
      Rake::Task["solrizer:fedora:solrize_objects"].invoke
      Rake::Task["solrizer:fedora:solrize_objects"].reenable

      Rockhall::JettyCleaner.clean("rockhall")
      Rockhall::JettyCleaner.clean("changeme")

      contents = Dir.glob("spec/fixtures/fedora/*.xml")
      contents.each do |file|
        ENV["foxml"] = file
        Rake::Task["repo:load"].invoke
        Rake::Task["repo:load"].reenable
      end

      # Re-sync all the solrs
      ENV["RAILS_ENV"] = "test"
      Rake::Task["hydra:jetty:solr_clean"].invoke
      Rake::Task["hydra:jetty:solr_clean"].reenable
      ENV["RAILS_ENV"] = "test"
      Rake::Task["solrizer:fedora:solrize_objects"].invoke
      Rake::Task["solrizer:fedora:solrize_objects"].reenable

      ENV["RAILS_ENV"] = "development"
      Rake::Task["hydra:jetty:solr_clean"].invoke
      Rake::Task["hydra:jetty:solr_clean"].reenable
      ENV["RAILS_ENV"] = "development"
      Rake::Task["solrizer:fedora:solrize_objects"].invoke
      Rake::Task["solrizer:fedora:solrize_objects"].reenable

    end

    desc "Validates a bag"
    task :check_bag => :environment do
      bag = BagIt::Bag.new ENV["bag"]
      puts "Validating #{ENV['bag']}"
      puts bag.valid?.to_s
    end

    namespace :gbv do

      desc "Validates a sip"
      task :validate => :environment do
        sip = Workflow::GbvSip.new("#{ENV['sip']}")
        if sip.valid?
          puts "Valid sip"
        else
          raise "Invalid sip"
        end
      end

    end

end