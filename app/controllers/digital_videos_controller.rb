class DigitalVideosController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls
  before_filter :enforce_asset_creation_restrictions, :only=>:new
  prepend_before_filter :enforce_review_controls, :only=>:edit

  def edit
    @afdoc = DigitalVideo.find(params[:id])
    respond_to do |format|
      format.html
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
    redirect_to catalog_path(params[:id])
  end

  def create
    @afdoc = DigitalVideo.new(params[:digital_video])
    @afdoc.apply_depositor_metadata(current_user.email)
    respond_to do |format|
      if @afdoc.save
        format.html { redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]), :notice => 'Video was successfully created.') }
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
        redirect_to(edit_digital_video_path(@afdoc, :wf_step=>params[:wf_step]), :alert => @afdoc.errors.messages.values.to_s)
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