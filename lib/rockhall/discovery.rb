require 'mediashelf/active_fedora_helper'
class Rockhall::Discovery

  include Hydra::RepositoryController
  include Hydra::AccessControlsEnforcement
  include Blacklight::SolrHelper

  # This is a push method that queries the Solr index used by Hydra
  # for publicly available objects and sends them to another solr index
  # Right now, it's only doing ArchivalVideo objects

  # adds objects to solr index
  def self.get_objects

    # query to return all objects in solr with discovery set to public
    solr_params = Hash.new
    solr_params[:fl]   = "id"
    solr_params[:q]    = "access_group_t:public AND collection_t:archival_video"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000
    solr_response = Blacklight.solr.find(solr_params)
    document_list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    # I get:
    #  undefined method `get_solr_response_for_doc_id' for Blacklight::SolrHelper:Module
    # if I try this:
    #  test = Blacklight::SolrHelper.get_solr_response_for_doc_id("rockhall:fixture_pbcore_document1")

    # connect to our other solr index
    solr = solr_connect

    # shove 'em in...
    document_list.each do |doc|
      retrieve = Hash.new
      retrieve[:q]  = 'id:"' + doc.id + '"'
      retrieve[:qt] = "document"
      response = Blacklight.solr.find(retrieve)
      solr.add response["response"]["docs"].first
      solr.commit
    end

  end

  # delete any ActiveFedora objects
  # used prior to an update
  def self.delete_objects
    solr = solr_connect
    solr_params = Hash.new
    solr_params[:q]    = 'active_fedora_model_s:"ActiveFedora::Base"'
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000
    solr_response = Blacklight.solr.find(solr_params)

    solr_response["response"]["docs"].each do |r|
      solr.delete_by_id r["id"]
      solr.commit
    end
  end

  def self.solr_connect
    solr = RSolr.connect :url => RH_CONFIG["solr_discovery"]
  end

end
