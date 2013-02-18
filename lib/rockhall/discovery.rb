# Rockhall::Discovery
#
# Provides methods for extracting publically available items in Hydra and indexing them
# into our Blacklight solr index.  Solr documents are simply copied from the Hydra solr index
# to the Blacklight solr index. #addl_solr_fields fields adds additional fields
# that are not present in the Hydra solr document.

class Rockhall::Discovery

  attr_accessor :solr

  # Creates a new Rockhall::Discovery session with a connection to the solr_discovery index 
  # defined in config/rockhall.yml
  def initialize
    @solr = RSolr.connect(:url => RH_CONFIG["solr_discovery"])
  end

  # Deletes all existing Hydra-related documents in Blacklight and adds
  # newly queried ones from Hydra's solr index.
  def update
    delete if blacklight_items.count > 0
    self.public_items.each do |obj|
      doc = obj.to_solr
      doc.merge!(addl_solr_fields(obj.pid))
      solr.add doc
    end
    solr.commit
  end

  # delete any ActiveFedora objects from the Blacklight index
  def delete
    blacklight_items.each do |r|
      solr.delete_by_id r["id"]
      solr.commit
    end
  end

  def public_items
    ActiveFedora::Base.find("read_access_group_t" => "public")
  end

  def blacklight_items(solr_params = Hash.new)
    solr_params[:fl]   = "id"
    solr_params[:qt]   = "document"
    solr_params[:rows] = 1000
    solr_params[:q]    = 'active_fedora_model_s:"DigitalVideo" OR active_fedora_model_s:"ArchivalVideo" OR active_fedora_model_s:"ActiveFedora::Base"'
    response = @solr.get 'select', :params => solr_params
    return response["response"]["docs"]
  end

  def addl_solr_fields(id)
    av = ArchivalVideo.find(id)
    return av.addl_solr_fields
  end

end
