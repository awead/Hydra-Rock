# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'mediashelf/active_fedora_helper'

class ReviewersController < ApplicationController

  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show
  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params
  #include MediaShelf::ActiveFedoraHelper
  #before_filter :require_solr, :require_fedora

  def show
  end

  def edit
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:id])

    respond_to do |format|
      format.html { render :edit }
      #format.js   { render :partial=>partial_name, :locals=>{"#{type}".to_sym =>node, "#{type}_counter".to_sym =>index}, :layout=>false }
    end
  end

  def update
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:id])
    logger.info "Applying licence #{params[:license]}"
    logger.info "Note should be: #{params[:asset][:assetReview][:notes][0]}"
    user = current_user.login
    @document_fedora.apply_reviewer_metadata(user,params[:license],{:notes=>params["asset"]["assetReview"]["notes"]["0"]})
    @document_fedora.save
    flash[:notice] = "Review changes saved."
    redirect_to url_for(:controller => "reviewers", :action => "edit")
  end


end