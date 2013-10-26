class ArchivalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Rockhall::Controllers

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update, :assign, :transfer, :destroy]
  before_filter :enforce_create_permissions, :only => [:new, :create]
  before_filter :enforce_delete_permissions, :only => [:destroy]
  before_filter :enforce_edit_permissions, :only => [:edit, :update, :transfer, :assign, :import]
  before_filter :update_session

  def edit
    @afdoc = ArchivalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
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

  def index
    redirect_to catalog_index_path
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
    @afdoc = ArchivalVideo.find(params[:id])

    if params[:wf_step].match("permissions")
      permissions_hash = format_permissions_hash(params[:document_fields]["permissions"])
      if @afdoc.update_permissions(permissions_hash)
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :notice => "Permissions updated successfully")
      else
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :alert => @afdoc.errors.messages)
      end
    else
      parameters_hash = format_parameters_hash params[:document_fields]
      if @afdoc.update_attributes(parameters_hash)
        record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => parameters_hash})
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :notice => "Video was updated successfully")
      else
        redirect_to(workflow_archival_video_path(@afdoc, params[:wf_step]), :alert => @afdoc.errors.messages)
      end
    end
  end

  def destroy
    @afdoc = ActiveFedora::Base.find(params[:id], :cast => true)
    title = @afdoc.title
    @afdoc.destroy_external_videos
    @afdoc.delete
    record_activity({"action" => "delete", "title" => title})
    flash[:notice]= "Deleted #{params[:id]} and associated videos"
    redirect_to catalog_index_path
  end

  # custom action for assigning videos to collections and archival series
  def assign
    @afdoc = ArchivalVideo.find(params[:id])
    @afdoc.update_collection(params["archival_video"])
    if @afdoc.descMetadata.changed?
      if @afdoc.save
        record_activity({"pid" => @afdoc.pid, "action" => "update", "title" => @afdoc.title, "changes" => format_parameters_hash(params["archival_video"])})
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