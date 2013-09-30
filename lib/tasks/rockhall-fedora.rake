namespace :rockhall do

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

end