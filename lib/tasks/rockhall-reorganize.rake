namespace :rockhall do
namespace :reorganize do

  desc "Reorganize collections"
  task :capture => :environment do
    ArchivalVideo.all.each do |av|
      av.capture_collections
      av.save if av.collections_saved?
    end
  end

  desc "Verifies that we caputred all the collection metadata"
  task :verify => :environment do
    ArchivalVideo.all.each do |av|
      print "Verifying #{av.pid}: "
      if av.collections_saved?
        puts "saved".colorize(:green)
      else
        puts "not saved".colorize(:red)
      end
    end
  end

  desc "Deletes all the collection relationships and metadata"
  task :purge => :environment do
    ArchivalVideo.all.each do |av|
      av.remove_collections
      av.save
    end
  end

end
end