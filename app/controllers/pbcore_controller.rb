require 'mediashelf/active_fedora_helper'

class PbcoreController < ApplicationController

  include MediaShelf::ActiveFedoraHelper
  before_filter :require_solr, :require_fedora

  def create
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:asset_id])
    type = params[:node]
    node, index = @document_fedora.insert_node(type)
    @document_fedora.save

    partial_name = "pbcore/edit/#{type}"
    respond_to do |format|
      format.html { redirect_to catalog_path(:id=>params[:asset_id]) }
      format.js   { render :partial=>partial_name, :locals=>{"#{type}".to_sym =>node, "#{type}_counter".to_sym =>index}, :layout=>false }
    end

  end

  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:asset_id])
    @document_fedora.remove_node(params[:node],params[:index])
    result = @document_fedora.save
    render :text=>result.inspect
    #redirect_to catalog_path(:id=>params[:asset_id])
  end


end