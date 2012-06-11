class DigitalVideosController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
  include Rockhall::Controller::ControllerBehaviour

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls
  before_filter :enforce_asset_creation_restrictions, :only=>:new
  #before_filter :enforce_viewing_context_for_show_requests, :only=>[:show]
  #before_filter :search_session, :history_session

  def edit
    @video = DigitalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @video }
    end
  end

  def new
    @video = DigitalVideo.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @video }
    end
  end

  def show
    update_session
    session[:viewing_context] = "browse"
    @video = DigitalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @video }
    end
  end

  def create
    @video = DigitalVideo.new(params[:digital_video])
    @video.apply_depositor_metadata(current_user.login)
    respond_to do |format|
      if @video.save
        format.html { redirect_to(@video, :notice => 'Video was successfully created.') }
        format.json { render :json => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.json { render :json => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    update_session
    @video = DigitalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_digital_video_path(@video, :wf_step=>params[:wf_step]))
    else
      @video.update_attributes(changes)
      logger.info("Updating these fields: #{changes.inspect}")
      if @video.save
        redirect_to(edit_digital_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_digital_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
      end
    end
  end

  def destroy
    af = ActiveFedora::Base.find(params[:id], :cast=>true)
    assets = af.destroy_child_assets
    af.delete
    msg = "Deleted #{params[:id]}"
    msg.concat(" and associated file_asset(s): #{assets.join(", ")}") unless assets.empty?
    flash[:notice]= msg
    redirect_to catalog_index_path()
  end

end
