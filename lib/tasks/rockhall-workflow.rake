namespace :rockhall do

  namespace :workflow do

    desc "Check SIPs for validity using DIR= for target"
    task :check => :environment do
      raise "You must specify a location using DIR=" unless ENV["DIR"]
      validate_sip Workflow::RockhallSip.new(ENV["DIR"])
    end

    desc "Check a directory of SIPs using DIR="
    task :check_batch => :environment do
      raise "You must specify a location using DIR=" unless ENV["DIR"]
      Dir.glob(File.join(ENV["DIR"], "*")).each do |dir|
        validate_sip Workflow::RockhallSip.new(dir)
      end
    end

    desc "Prepare SIPs for ingestion using DIR="
    task :prep => :environment do
      raise "You must specify a location using DIR=" unless ENV["DIR"]
      sip = Workflow::RockhallSip.new(ENV["DIR"])
      if sip.valid?
        sip.prepare 
        puts prep_message(sip)
      end
    end

    desc "Prepares a directory of SIPs for ingestion using DIR="
    task :prep_batch => :environment do
      raise "You must specify a location using DIR=" unless ENV["DIR"]
      Dir.glob(File.join(ENV["DIR"], "*")).each do |dir|
        sip = Workflow::RockhallSip.new(dir)
        if sip.valid?
          sip.prepare 
          puts prep_message(sip)
        end
      end
      
    end    

    desc "Ingest a prepared SIP using DIR="
    task :ingest => :environment do
      raise "You must specify a location using DIR=" unless ENV["DIR"]
      sip = Workflow::RockhallSip.new(ENV["DIR"])
      Workflow::RockhallIngest.new(sip).process if sip.valid?
    end

  end

end

def validate_sip sip
  if sip.valid?
    puts "#{sip.base} is valid".colorize(:green)
  else
    puts "#{sip.base} is not valid - see log for details".colorize(:red)
  end
end

def prep_message sip
  path = File.join(RH_CONFIG["location"], sip.base)
  print "#{sip.base} has been prepared, to ingest, use DIR=#{path}"
end
