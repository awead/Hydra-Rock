class ArchivalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update, :assign, :transfer, :destroy]
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
        format.html { redirect_to(edit_archival_video_path(@afdoc), :notice => "Video was successfully created.") }
        format.json { render :json => @afdoc, :status => :created, :location => @afdoc }
      else
        format.html {
          flash[:alert] = @afdoc.errors.messages
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

    if params[:wf_step].match("permissions")
      permissions_hash = format_permissions_hash(changes["permissions"])
      if @afdoc.update_permissions(permissions_hash)
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :notice => "Permissions updated successfully")
      else
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :alert => @afdoc.errors.messages)
      end
    else
      if changes.empty?
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]))
      else
        if @afdoc.update_metadata(changes)
          record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => changes}) unless changes.nil?
          redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :notice => "Video was updated successfully")
        else
          redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :alert => @afdoc.errors.messages)
        end
      end
    end
  end

  def destroy
    @afdoc = ActiveFedora::Base.find(params[:id], :cast=>true)
    title = @afdoc.title
    @afdoc.destroy_external_videos
    @afdoc.delete
    record_activity({"action" => "delete", "title" => title})
    flash[:notice]= "Deleted #{params[:id]} and associated videos"
    redirect_to catalog_index_path
  end

  # custom action for assigning videos to collections and series
  def assign message = Array.new
    @afdoc = ArchivalVideo.find(params[:id])

    message << update_relation("collection")
    message << update_relation("series")

    unless message.blank?
      if @afdoc.save
        record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => params["archival_video"]})
        redirect_to(workflow_archival_video_path(@afdoc, "collections"), :notice => "Video was updated successfully")
      else
        redirect_to(workflow_archival_video_path(@afdoc, "collections"), :alert => @afdoc.errors.messages)
      end
    else
      redirect_to(workflow_archival_video_path(params["id"], "collections"), :notice => "No changes made")
    end
  end

  # renders a form for importing videos from another object
  def import
    render :partial => "import"
  end

  # transfers the videos from a source object to the destination object
  def transfer
    @afdoc = ArchivalVideo.find(params[:id])
    if params["source"].empty?
      flash[:error] = "Please enter a source pid"
    elsif @afdoc.transfer_videos_from_pid(params["source"])
      flash[:notice] = "Videos were transferred successfully"
    else
      flash[:error] = @afdoc.errors.messages.values.join("<br/>")
    end
    render :partial => "import"
  end

end