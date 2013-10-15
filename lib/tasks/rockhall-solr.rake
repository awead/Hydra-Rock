namespace :rockhall do

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

end