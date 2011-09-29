namespace :hydra do

  namespace :jetty do

    desc "Deletes everytyhing from the solr index"
    task :solr_clean => :environment do

      Blacklight.solr.delete_by_query("*:*")
      Blacklight.solr.commit

    end

    desc "Cleans out your fedora repository"
    task :fedora_clean => :environment do

      Hydrangea::JettyCleaner.clean("changeme")

    end

  end

end
