class ReviewersController < ApplicationController

  include Hydra::Assets
  include Blacklight::Catalog
  include Rockhall::Controller::ControllerBehavior

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls
  before_filter :enforce_review_controls, :only=>:edit

  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params

  def edit
    @afdoc = get_model_from_pid(params[:id])
    @update_path = @afdoc.class.to_s.underscore + "_path"
    respond_to do |format|
      format.html { setup_next_and_previous_documents }
    end
  end

  def show
    @afdoc = get_model_from_pid(params[:id])
    @update_path = @afdoc.class.to_s.underscore + "_path"
    redirect_to eval(@update_path)
  end

end