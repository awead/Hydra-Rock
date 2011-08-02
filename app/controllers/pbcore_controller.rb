require 'mediashelf/active_fedora_helper'

class PbcoreController < ApplicationController

  include MediaShelf::ActiveFedoraHelper
  before_filter :require_solr, :require_fedora

  #def new
  #  render :partial=>"contributors/new"
  #end

  def create
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:asset_id])
    type = params[:node]
    node, index = @document_fedora.insert_node(type)
    @document_fedora.save
    partial_name = "pbcore/edit/#{type}"
    # Local variable names match the defaults that the render command uses with edit action
    render :partial=>partial_name, :locals=>{"#{type}".to_sym =>node, "#{type}_counter".to_sym =>index}, :layout=>false
  end

  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:asset_id])
    @document_fedora.remove_node(params[:node],params[:index])
    result = @document_fedora.save
    render :text=>result.inspect
  end

end