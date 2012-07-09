class Hydrangea::JettyCleaner

  def self.clean(pidspace=nil)
    raise "You're trying to clean out your production Fedora instance!!" if Rails.env == "production"

    solr_params = Hash.new
    solr_params[:fl]   = "id"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000
    solr_params[:q]    = "*:*"
    solr_response = Blacklight.solr.find(solr_params)
    docs = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    docs.each do |doc|
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
