class DigitalVideosController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
  include Rockhall::Controller::ControllerBehaviour

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls
  before_filter :enforce_asset_creation_restrictions, :only=>:new
  prepend_before_filter :enforce_review_controls, :only=>:edit
  #before_filter :enforce_viewing_context_for_show_requests, :only=>[:show]
  #before_filter :search_session, :history_session

  def edit
    @afdoc = DigitalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  def new
    @afdoc = DigitalVideo.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @afdoc }
    end
  end

  def show
    update_session
    session[:viewing_context] = "browse"
    @afdoc = DigitalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  def create
    @afdoc = DigitalVideo.new(params[:digital_video])
    @afdoc.apply_depositor_metadata(current_user.login)
    respond_to do |format|
      if @afdoc.save
        format.html { redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Video was successfully created.') }
        format.json { render :json => @afdoc, :status => :created, :location => @afdoc }
      else
        format.html { render :action => "new" }
        format.json { render :json => @afdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    update_session
    @afdoc = DigitalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]))
    else
      @afdoc.update_attributes(changes)
      logger.info("Updating these fields: #{changes.inspect}")
      if @afdoc.save
        redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
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
