class Rockhall::JettyCleaner

  # Queries the solr index specificed in solr.yml for all the documents in the index, then
  # deletes each one from the given +pidspace+.  If no pidspace is nil, it will delete all
  # the objects from fedora.  Ex:
  #  > Rockhall::JettyCleaner.clean("changeme")
  # Will delete all the objects in fedora with the *changeme* pid.  This is useful during
  # testing and development when you want to remove the objects created during the testing
  # process, but want to keep your fixtures intact.
  def self.clean(pidspace=nil)
    raise "You're trying to clean out your production Fedora instance!!" if Rails.env == "production"

    solr = RSolr.connect :url => Blacklight.solr.uri.to_s
    response = solr.get 'select', :params => {:q => '*:*', :qt=> 'document', :fl => 'id', :rows => '200'}

    response["response"]["docs"].each do |doc|
      id = doc["id"]
      namespace, number = id.split(/:/)
      if namespace == pidspace or pidspace.nil?
        puts "Deleting #{id}"
        ActiveFedora::Base.find(id).delete
      else
        puts "Keeping #{id}"
      end
    end
  end

end
