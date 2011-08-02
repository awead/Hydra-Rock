require 'mediashelf/active_fedora_helper'

class ContributorsController < ApplicationController
  
  include MediaShelf::ActiveFedoraHelper
  before_filter :require_solr, :require_fedora
  
  # Don't know if this is used...
  def new
    render :partial=>"contributors/new"
  end
  
  def create
    af_model = retrieve_af_model(params[:content_type], :default=>HydrangeaArticle)
    @document_fedora = af_model.find(params[:asset_id])
    
    ct = params[:contributor_type]
    inserted_node, new_node_index = @document_fedora.insert_contributor(ct)
    @document_fedora.save
    if params[:content_type] == "archival_image"
      partial_name = "rockhall_contributors/edit_#{ct}"
    else
      partial_name = "contributors/edit_#{ct}"
    end
    render :partial=>partial_name, :locals=>{"edit_#{ct}".to_sym =>inserted_node, "edit_#{ct}_counter".to_sym =>new_node_index}, :layout=>false
  end
  
  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>HydrangeaArticle)
    @document_fedora = af_model.find(params[:asset_id])
    @document_fedora.remove_contributor(params[:contributor_type], params[:index])
    result = @document_fedora.save
    render :text=>result.inspect
  end
  
end
