class ExternalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls

  def edit
    @afdoc = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  def show
    redirect_to catalog_path(params[:id])
  end

  def update
    @afdoc = ExternalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Changes: ' + params.inspect)
    else
      @afdoc.update_attributes(changes)
      if @afdoc.save
        redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
      end
    end
  end

end
