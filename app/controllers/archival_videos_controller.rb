class ArchivalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update, :assign, :transfer]
  before_filter :enforce_access_controls
  before_filter :enforce_asset_creation_restrictions, :only=>:new
  prepend_before_filter :enforce_review_controls, :only=>:edit

  def edit
    @afdoc = ArchivalVideo.find(params[:id])
    respond_to do |format|
      format.html
      format.json  { render :json => @afdoc }
    end
  end

  def new
    @afdoc = ArchivalVideo.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @afdoc }
    end
  end

  def show
    redirect_to catalog_path(params[:id])
  end

  def create
    @afdoc = ArchivalVideo.new(params[:archival_video])
    @afdoc.apply_depositor_metadata(current_user.email)
    respond_to do |format|
      if @afdoc.save
        record_activity({"pid" => @afdoc.pid, "action" => "create", "title" => @afdoc.title})
        format.html { redirect_to(edit_archival_video_path(@afdoc), :notice => 'Video was successfully created.') }
        format.json { render :json => @afdoc, :status => :created, :location => @afdoc }
      else
        format.html {
          flash[:alert] = @afdoc.errors.messages.values.to_s
          render :action => "new"
        }
        format.json { render :json => @afdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    update_session
    @afdoc = ArchivalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]))
    else
      @afdoc.update_attributes(changes)
      if @afdoc.save
        record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => changes})
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :alert => @afdoc.errors.messages.values.to_s)
      end
    end
  end

  def destroy
    @afdoc = ActiveFedora::Base.find(params[:id], :cast=>true)
    title = @afdoc.title
    assets = @afdoc.destroy_child_assets
    @afdoc.delete
    record_activity({"action" => "delete", "title" => title})
    msg = "Deleted #{params[:id]}"
    msg.concat(" and associated file_asset(s): #{assets.join(", ")}") unless assets.empty?
    flash[:notice]= msg
    redirect_to catalog_index_path()
  end

  # custom action for assigning videos to collections and series
  def assign message = String.new
    @afdoc = ArchivalVideo.find(params[:id])

    message << update_relation("collection")
    message << update_relation("series")

    unless message.blank?
      if @afdoc.save
        record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => params["archival_video"]})
        redirect_to(workflow_archival_video_path(@afdoc, "collections"), :notice => message)
      else
        redirect_to(workflow_archival_video_path(@afdoc, "collections"), :alert => @afdoc.errors.messages.values.to_s)
      end
    else
      redirect_to(workflow_archival_video_path(params["id"], "collection"), :notice => "No changes made")
    end
  end

  # renders a form for importing videos from another object
  def import
    render :partial => "import"
  end

  # transfers the videos from a source object to the destination object
  def transfer
    message = verify_transfer
    if message.empty?
      destination = ActiveFedora::Base.find(params["id"], :cast => true)
      source      = ActiveFedora::Base.find(params["source"], :cast => true)
      destination.transfer_videos_from source
      flash[:notice] = "Transferred #{source.external_videos.count} videos to #{destination.title}"
      render :partial => "import"
    else
      flash[:error]= message
      render :partial => "import"
    end
  end

  # Verifies the parameters for transferring videos.  An empty string indicates the parameters are acceptable.
  def verify_transfer error = String.new
    error = "You must enter an id." if params["source"].empty?
    error = "ID #{params["source"]} does not exist." unless ActiveFedora::Base.exists?(params["source"])
    error = "Source ID cannot be the same as the destination ID." if params["source"] == params["id"]
    return error
  end


end