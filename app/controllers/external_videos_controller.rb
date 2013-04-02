class ExternalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
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
    if parent.is_a?(Foo)

    else
      redirect_to(edit_archival_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => "Can't add a tape to a #{parent.class}")
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
