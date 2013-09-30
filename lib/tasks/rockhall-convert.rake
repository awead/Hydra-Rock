namespace :rockhall do

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
    end

    desc "Use Fedora's fedora-modify-control-group.sh to convert inline datastreams to managed datastreams"
    task :datastreams => :environment do
      raise "fedora-modify-control-group.sh doesn't appear to be in your PATH" unless `which fedora-modify-control-group.sh`.length > 0
      failed = Array.new
      ActiveFedora::Base.find(:all).each do |obj|
        ["descMetadata", "rightsMetadata", "properties", "assetReview", "mediaInfo"].each do |dsType|
          if obj.datastreams.include?(dsType) && obj.datastreams[dsType].controlGroup == "X"
            begin
              `fedora-modify-control-group.sh migratedatastreamcontrolgroup http #{ActiveFedora.config.credentials[:user]} #{ActiveFedora.config.credentials[:password]} #{obj.pid} #{dsType} M`
            rescue
              failed << "#{obj.pid} #{dsType} failed"
            end
          end
        end
      end
      if failed.length > 0
        puts "#{failed.length} datastreams did not convert:"
        puts failed.join("\n")
      end    
    end

  end

end