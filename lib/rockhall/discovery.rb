require 'mediashelf/active_fedora_helper'
class Rockhall::Discovery

  include Hydra::RepositoryController
  include Hydra::AccessControlsEnforcement
  include Blacklight::SolrHelper

  # Queries either the local Solr index used by Hydra for publicly available ArchivalVideo objects,
  # or queries the remote discovery index for all ArchivalVideo objects
  def self.get_objects(opts={})
    solr_params = Hash.new
    solr_params[:fl]   = "id"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000

    if opts[:remote]
      solr_params[:q]    = 'has_model_s:"info:fedora/afmodel:ArchivalVideo"'
      solr = solr_connect
      solr_response = solr.find(solr_params)
    else
      solr_params[:q]    = 'access_group_t:public AND has_model_s:"info:fedora/afmodel:ArchivalVideo"'
      solr_response = Blacklight.solr.find(solr_params)
    end

    return solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}
  end

  # updates Blacklight index with results from get_objects
  def self.update
    # connect to our other solr index
    solr = solr_connect
    docs = get_objects
    # shove 'em in...
    docs.each do |doc|
      retrieve = Hash.new
      retrieve[:q]  = 'id:"' + doc.id + '"'
      retrieve[:qt] = "document"
      response = Blacklight.solr.find(retrieve)
      solr.add response["response"]["docs"].first
      solr.commit
    end
  end

  # delete any ActiveFedora objects from the Blacklight index
  def self.delete_objects
    solr = solr_connect
    docs = get_objects({:remote=>TRUE})
    docs.each do |r|
      solr.delete_by_id r["id"]
      solr.commit
    end
  end

  def self.solr_connect
    RSolr::Ext.connect({:url => RH_CONFIG["solr_discovery"]})
  end

end
