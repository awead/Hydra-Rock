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
      Rockhall::JettyCleaner.clean("arc")
    end

    desc "Using PID, export a Fedora object and its associated objects to spec/fixtures/exports"
    task :export => :environment do
      raise "Must specify a pid using PID=" unless ENV['PID']
      dir = "spec/fixtures/exports"
      obj = ActiveFedora::Base.find(ENV['PID'], :cast => true)
      unless obj.external_video_ids.empty?
        puts "Exporting related external videos:"
        obj.external_video_ids.each do |id|
          puts "\t#{id}"
          ActiveFedora::FixtureExporter.export_to_path(id, dir)
        end
      end
      puts "Exporting object #{obj.pid}"
      ActiveFedora::FixtureExporter.export_to_path(obj.pid, dir)
    end

    desc "Export all objects from fedora"
    task :export_all => :environment do
      dir = "spec/fixtures/exports"
      ActiveFedora::Base.connection_for_pid('foo:1') # Loads Rubydora connection with fake object
      success = 0
      ActiveFedora::Base.fedora_connection[0].connection.search(nil) do |object|
        ActiveFedora::FixtureExporter.export_to_path(object.pid, dir)
        success = success + 1
      end
      puts "Complete: #{success.to_s} objects exported"
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
        rescue => e
          failed << object.pid.to_s + ": " + e.inspect
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

  namespace :convert do

    desc "Convert videos to their new models"
    task :videos => :environment do
      ExternalVideo.all.each do |v|
        puts "Converting #{v.pid} to new ExternalVideo"
        v.from_external_video
        v.save
      end

      ActiveFedora::Base.all.each do |obj|
        video = ActiveFedora::Base.find(obj.pid, :cast => true)
        if video.is_a? (ArchivalVideo)
          puts "Converting #{video.pid} to a new ArchivalVideo"
          ev = video.from_archival_video
          unless ev.nil?
            video.external_videos << ev
            ev.save
          end
          video.save
        end

        if video.is_a? (DigitalVideo)
          puts "Converting #{video.pid} from DigitalVideo to ArchivalVideo"
          av = video.from_digital_video
          av.save
        end
      end
    end

  end

end