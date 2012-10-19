namespace :hydra do

  namespace :jetty do

    desc "Deletes everytyhing from the solr index"
    task :solr_clean => :environment do

      Blacklight.solr.delete_by_query("*:*")
      Blacklight.solr.commit

    end

    desc "Cleans out your fedora repository"
    task :fedora_clean => :environment do

      # You really don't want to do this in production
      unless Rails.env == "production"
        Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      end

    end

  end

end
