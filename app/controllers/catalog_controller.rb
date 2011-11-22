# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show
  prepend_before_filter :enforce_review_controls, :only=>:edit

  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params

  # Right now, anyone in the review group gets redirected to the reviewers edit page
  def enforce_review_controls
    user_groups = RoleMapper.roles(current_user.login)
    if user_groups.include?("reviewer")
      flash[:notice] = "You have been redirected to the review page for this document"
      redirect_to url_for(:controller=>"reviewers", :action=>"edit")
    end
  end

end
