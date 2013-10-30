namespace :rockhall do

  namespace :convert do

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