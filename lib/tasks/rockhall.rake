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

  desc "Generates thumbnail for PID"
  task :thumbnail => :environment do
    video = ActiveFedora::Base.find(ENV['PID'], :cast => true)
    video.save if video.add_thumbnail
  end  

  desc "Generates thumbnails for all videos"
  task :thumbnail_all => :environment do
    ArchivalVideo.find(:all).each do |video|
      print "Creating thumbnail for #{video.pid}: "
      if video.get_thumbnail_url.nil?
        if video.add_thumbnail
          video.save
          puts "ok"
        else
          puts "FAILED"
        end
      else
        puts "already has one"
      end
    end
  end

  namespace :fedora do

    desc "Load a single object into fedora specified by FILE=path/to/file"
    task :load_file => :environment do
      raise "Must specify the full path to a file.  Ex:  FILE='spec/fixtures/fedora/rrhof_123.foxml.xml" unless ENV['FILE']
      contents = Dir.glob("spec/fixtures/fedora/*.xml")
      pid = ActiveFedora::FixtureLoader.import_to_fedora(ENV['FILE'])
      ActiveFedora::FixtureLoader.index(pid)
    end

    desc "Load fixtures from spec/fixtures/fedora, use DIR=path/to/directory to specify other location"
    task :load => :environment do
      contents = ENV['DIR'] ? Dir.glob(File.join(ENV['DIR'], "*.xml")) : Dir.glob("spec/fixtures/fedora/*.xml")
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
      Rockhall::JettyCleaner.clean("cucumber")
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
        print "Converting #{v.pid} to new ExternalVideo: "
        if v.converted == "yes"
          puts "already converted"
        else
          begin
            v.from_external_video
            v.converted = "yes"
            puts "ok"
          rescue => e
            v.converted = "no"
            puts "FAILED"
            puts e.inspect
          end
          v.save
        end 
      end

      ArchivalVideo.all.each do |v|
        print "Converting #{v.pid} to new ArchivalVideo: "
        if v.converted == "yes"
          puts "already converted"
        else
          begin
            ev = v.from_archival_video
            unless ev.nil?
              v.external_videos << ev
              # prevent newly created ExternalVideos from being converted
              ev.converted = "yes"
              ev.save
            end
            v.converted = "yes"
            puts "ok"
          rescue => e
            v.converted = "no"
            puts "FAILED"
            puts e.inspect
          end
          v.save
        end 
      end

      DigitalVideo.all.each do |v|
        print "Converting DigitalVideo #{v.pid} to new ArchivalVideo: "
        if v.converted == "yes"
          puts "status = #{v.converted}"
        else
          begin
            av = v.from_digital_video
            av.converted = "yes"
            puts "ok"
          rescue
            av.converted = "no"
            puts "FAILED"
            puts e.inspect
          end          
          av.save
        end 
      end
    end

  end

end