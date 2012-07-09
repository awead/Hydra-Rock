namespace :solrizer do

  namespace :fedora  do
    desc 'Index a fedora object of the given pid.'
    task :solrize => :environment do
      if ENV['PID']
        puts "indexing #{ENV['PID'].inspect}"
        solrizer = Solrizer::Fedora::Solrizer.new :index_full_text=>TRUE
        solrizer.solrize(ENV['PID'])
        puts "Finished shelving #{ENV['PID']}"
      else
        puts "You must provide a pid using the format 'solrizer::solrize_object PID=sample:pid'."
      end
    end

    desc 'Index all objects in the repository.'
    task :solrize_objects => :environment do
      solrizer = Solrizer::Fedora::Solrizer.new :index_full_text=>TRUE
      solrizer.solrize_objects
    end
  end

end
