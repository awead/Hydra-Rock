class ExternalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update, :destroy]
  before_filter :update_session

  def new
    @afdoc = ExternalVideo.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @afdoc }
    end
  end
  
  # When using the webapp, we only create physical instantiations and attach them
  # to existing ArchivalVideos
  def create
    parent = ActiveFedora::Base.find(params[:archival_video_id], :cast => true)
    if parent.is_a?(ArchivalVideo)
      @afdoc = ExternalVideo.new
      @afdoc.define_physical_instantiation
      @afdoc.update_attributes(format_parameters_hash(params["document_fields"]))
      @afdoc.apply_depositor_metadata(current_user.email)
      respond_to do |format|
        if @afdoc.save
          parent.external_videos << @afdoc
          parent.save
          @afdoc.save
          format.html { redirect_to(edit_archival_video_path(parent), :notice => "Tape was successfully created.") }
          format.json { render :json => @afdoc, :status => :created, :location => @afdoc }
        else
          format.html {
            flash[:alert] = @afdoc.errors.messages
            render :action => "new"
          }
          format.json { render :json => @afdoc.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to(catalog_path(params[:archival_video_id]), :notice => "Can't add a tape to a #{parent.class}.")
    end
  end

  def edit
    @afdoc = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  # renders a list of external videos from a given video
  def index
    @afdoc = ActiveFedora::Base.find(params[:archival_video_id], :cast => true)
    respond_to do |format|
      format.html { render :partial => "external_videos/show/list" if request.xhr? }
    end
  end

  def show
    @afdoc = ExternalVideo.find(params[:id])
    partial = @afdoc.generation.first.match("Original") ? "physical" : "digital"
    respond_to do |format|
      format.html { 
        if request.xhr?
          render :partial => "external_videos/show/tabular_display_#{partial}", :locals => { :video => @afdoc }
        else
          redirect_to catalog_path(params[:id])
        end
      }
    end
  end

  def update
    @afdoc = ExternalVideo.find(params[:id])
    if @afdoc.update_attributes(format_parameters_hash(params[:document_fields]))
      redirect_to(edit_external_video_path(@afdoc), :notice => "Video was updated successfully")
    else
      redirect_to(edit_external_video_path(@afdoc), :alert => @afdoc.errors.messages)
    end
  end

  def destroy
    @afdoc = ActiveFedora::Base.find(params[:id], :cast=>true)
    parent = @afdoc.parent
    @afdoc.delete
    msg = "Deleted #{params[:id]}"
    flash[:notice]= msg
    redirect_to edit_archival_video_path(parent)
  end

end
