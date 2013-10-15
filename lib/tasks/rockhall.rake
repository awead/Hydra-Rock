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

  desc "Updates all ExternalVideo files with their file metadata"
  task :update_files => :environment do
    ExternalVideo.find(:all).each do |v|
      v.update_file_info
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