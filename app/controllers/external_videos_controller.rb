class ExternalVideosController < ApplicationController
  include Blacklight::Catalog
  #include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
  include Rockhall::Controller::ControllerBehaviour


  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls
  #before_filter :enforce_viewing_context_for_show_requests, :only=>[:show]
  #before_filter :search_session, :history_session

  def edit
    @afdoc = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  def show
    session[:viewing_context] = "browse"
    @afdoc = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.js
    end
  end

  def update
    @afdoc = ExternalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Changes: ' + params.inspect)
    else
      @afdoc.update_attributes(changes)
      logger.info("Updating these fields: #{changes.inspect}")
      if @afdoc.save
        redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_external_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
      end
    end
  end

end
