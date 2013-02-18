namespace :rockhall do

  desc "Export items from hydra into blacklight"
  task :discovery => :environment do
    discovery = Rockhall::Discovery.new
    discovery.delete
    discovery.update
  end

  desc "Validates a bag"
  task :check_bag => :environment do
    bag = BagIt::Bag.new ENV["bag"]
    puts "Validating #{ENV['bag']}"
    puts bag.valid?.to_s
  end  

  namespace :fedora do

    desc "Load a single object into fedora specified by FILE=path/to/file"
    task :load_file => :environment do
      raise "Must specify the full path to a file.  Ex:  FILE='spec/fixtures/fedora/rrhof_123.foxml.xml" unless ENV['FILE']
      contents = Dir.glob("spec/fixtures/fedora/*.xml")
      pid = ActiveFedora::FixtureLoader.import_to_fedora(ENV['FILE'])
      ActiveFedora::FixtureLoader.index(pid)
    end

    desc "Load fixtures into an empty Fedora"
    task :load => :environment do
      contents = Dir.glob("spec/fixtures/fedora/*.xml")
      contents.each do |file|
        begin
          pid = ActiveFedora::FixtureLoader.import_to_fedora(file)
          ActiveFedora::FixtureLoader.index(pid)
        rescue
          puts "Failed to load #{file.to_s}"
        end
      end
    end
    
    desc "Deletes all objects from Fedora repository and loads fixtures"
    task :refresh => :environment do
      raise "You don't want to run this task in production.  You'll royally f#&@ things up." if Rails.env.match("production")
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      Rockhall::JettyCleaner.clean("rockhall")
      Rockhall::JettyCleaner.clean("rrhof")
      Rake::Task["rockhall:fedora:load"].invoke
      Rake::Task["rockhall:fedora:load"].reenable
    end
  
    desc "Clean out unwanted objects from Fedora"
    task :clean => :environment do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
    end

    desc "Cleans out everytyhing from Fedora"
    task :empty => :environment do
      raise "You don't want to run this task in production.  You'll royally f#&@ things up." if Rails.env.match("production")
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      Rockhall::JettyCleaner.clean("rockhall")
      Rockhall::JettyCleaner.clean("rrhof")
    end

  end

  namespace :solr do

    desc "Deletes everytyhing from the solr index"
    task :clean => :environment do
      Blacklight.solr.delete_by_query("*:*")
      Blacklight.solr.commit
    end

    desc "Index a single object in solr specified by PID="
    task :index => :environment do
      raise "Must specify a pid.  Ex:  PID='changeme:12" unless ENV['PID']
      ActiveFedora::Base.connection_for_pid('foo:1') # Loads Rubydora connection with fake object
      ActiveFedora::Base.find(ENV['PID'], cast: true).update_index
    end

    desc 'Index all objects in the repository.'
    task :index_all => :environment do
      ActiveFedora::Base.connection_for_pid('foo:1') # Loads Rubydora connection with fake object
      success = 0
      failed  = Array.new
      ActiveFedora::Base.fedora_connection[0].connection.search(nil) do |object|
        begin
          ActiveFedora::Base.find(object.pid, cast: true).update_index
          success = success + 1
        rescue
          failed << object.pid.to_s
        end
      end
      puts "Complete: #{success.to_s} objects indexed, #{failed.count.to_s} failed"
      puts "#{failed.join("\n")}" if failed.count > 0
    end
  
  end

  namespace :gbv do

    desc "Validates a sip from George Blood Audio and Video"
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