namespace :rockhall do

    desc "Export items from hydra into blacklight"
    task :discovery => :environment do
      Rockhall::Discovery.delete_objects
      Rockhall::Discovery.get_objects
    end

    desc "Delete everything from Fedora and reindex our fixtures"
    task :reload_fixtures => :environment do
      Hydrangea::JettyCleaner.clean()

      contents = Dir.entries("spec/fixtures/fedora/")
      contents.each do |file|
        if file.end_with?("xml")
          ENV["fixture"] = "spec/fixtures/fedora/" + file
          Rake::Task["hydra:import_fixture"].invoke
          Rake::Task["hydra:import_fixture"].reenable
        end
      end

    end

end