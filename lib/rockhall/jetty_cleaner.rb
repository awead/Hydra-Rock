class Rockhall::JettyCleaner

  def self.clean(pidspace=nil)
    raise "You're trying to clean out your production Fedora instance!!" if Rails.env == "production"

    # Use RSolr to query solr for all the docs
    solr = RSolr.connect :url => Blacklight.solr.uri.to_s
    response = solr.get 'select', :params => {:q => '*:*'}

    response["response"]["docs"].each do |doc|
      namespace, number = doc.id.split(/:/)
      if namespace == pidspace or pidspace.nil?
        puts "Deleting #{doc.id}"
        ActiveFedora::Base.find( doc.id ).delete
      else
        puts "Keeping #{doc.id}"
      end
    end
  end

end
