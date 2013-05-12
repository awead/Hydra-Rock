class ExternalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls

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
      @afdoc.update_attributes(params["document_fields"])
      @afdoc.apply_depositor_metadata(current_user.email)
      respond_to do |format|
        if @afdoc.save
          parent.external_videos << @afdoc
          parent.save
          @afdoc.save
          format.html { redirect_to(edit_archival_video_path(parent), :notice => 'Tape was successfully created.') }
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
      redirect_to(edit_archival_video_path(@afdoc), :notice => "Can't add a tape to a #{parent.class}")
    end
  end

  def edit
    @afdoc = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
  end

  def show
    @afdoc = ExternalVideo.find(params[:id])
    partial = @afdoc.generation.first.match("Original") ? "physical" : "digital"
    respond_to do |format|
      format.html  { render :partial => "external_videos/show/tabular_display_#{partial}", :locals => { :video => @afdoc } }
      format.js
    end
  end

  def update
    @afdoc = ExternalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_external_video_path(@afdoc), :notice => 'Changes: ' + params.inspect)
    else
      if @afdoc.update_metadata(changes)
        redirect_to(edit_external_video_path(@afdoc), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_external_video_path(@afdoc), :alert => @afdoc.errors.messages)
      end
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
