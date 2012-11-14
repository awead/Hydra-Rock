namespace :rockhall do

    desc "Export items from hydra into blacklight"
    task :discovery => :environment do
      Rockhall::Discovery.delete_objects
      Rockhall::Discovery.update
    end

    desc "Load fixtures into an empty Fedora"
    task :load_fixtures => :environment do
      contents = Dir.glob("spec/fixtures/fedora/*.xml")
      contents.each do |file|
        ENV["foxml"] = file
        Rake::Task["repo:load"].invoke
        Rake::Task["repo:load"].reenable
      end
    end

    desc "Clean out unwanted objects from Fedora"
    task :fedora_clean => :environment do
      Rockhall::JettyCleaner.clean("changeme")
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