require 'mediashelf/active_fedora_helper'

class SubjectsController < ApplicationController
  
  include MediaShelf::ActiveFedoraHelper
  before_filter :require_solr, :require_fedora
  
  #def new
  #  render :partial=>"contributors/new"
  #end
  
  def create
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalImage)
    @document_fedora = af_model.find(params[:asset_id])
    
    ct = params[:subject_type]
    inserted_node, new_node_index = @document_fedora.insert_subject(ct)
    @document_fedora.save
    #partial_name = "subjects/edit_#{ct}"
    #render :partial=>partial_name, :locals=>{"edit_#{ct}".to_sym =>inserted_node, "edit_#{ct}_counter".to_sym =>new_node_index}, :layout=>false
    partial_name = "subjects/types/edit_#{ct}"
    render :partial=>partial_name, :locals=>{"edit_#{ct}".to_sym =>inserted_node, "#{ct}_counter".to_sym =>new_node_index}, :layout=>false
  end
  
  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalImage)
    @document_fedora = af_model.find(params[:asset_id])
    @document_fedora.remove_subject(params[:index])
    result = @document_fedora.save
    render :text=>result.inspect
  end
  
end
