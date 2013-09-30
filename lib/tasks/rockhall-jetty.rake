namespace :rockhall do

  namespace :jetty do

    desc "Override jetty:clean with our own url (as needed)"
    task :clean => :environment do
      Jettywrapper.url = "https://github.com/projecthydra/hydra-jetty/archive/solr-4.3.zip"
      Jettywrapper.clean
    end
    
    desc "Load solr configuration into jetty directory"
    task :config_solr => :environment do
      rm_rf Dir.glob("jetty/solr/*")
      cp_r("solr", "jetty", :remove_destination => :true)
    end
  
    desc "Load fedora configuration into jetty directory"
    task :config_fedora do
      cp("fedora/conf/development/fedora.fcfg", "jetty/fedora/default/server/config/", :verbose => true)
      cp("fedora/conf/test/fedora.fcfg", "jetty/fedora/test/server/config/", :verbose => true)
    end

    desc "Configure jetty with local Fedora and Solr files"
    task :config => ['jetty:stop', :clean] do
      Rake::Task["rockhall:jetty:config_fedora"].reenable
      Rake::Task["rockhall:jetty:config_fedora"].invoke
      Rake::Task["rockhall:jetty:config_solr"].reenable
      Rake::Task["rockhall:jetty:config_solr"].invoke
    end

  end

end