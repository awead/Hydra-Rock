# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'mediashelf/active_fedora_helper'

class ReviewersController < ApplicationController

  include Hydra::Assets
  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Catalog


  # These before_filters apply the hydra access controls
  #before_filter :require_solr
  before_filter :enforce_access_controls
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show
  before_filter :enforce_review_controls, :only=>:edit
  before_filter :apply_reviewer_metadata, :only=>:update
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

  def enforce_review_controls
    user_groups = RoleMapper.roles(current_user.login)
    unless user_groups.include?("reviewer")
      flash[:notice] = "You are not allowed to review this document"
      redirect_to url_for(:root)
    end
  end

  def apply_reviewer_metadata
    @document.reviewer = current_user.login
    @document.date_updated = DateTime.now.strftime("%Y-%m-%d")
  end

end