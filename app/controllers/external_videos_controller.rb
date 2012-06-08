class ExternalVideosController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls
  #before_filter :enforce_viewing_context_for_show_requests, :only=>[:show]
  #before_filter :search_session, :history_session

  def edit
    @video = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @video }
    end
  end

  def show
    session[:viewing_context] = "browse"
    @video = ExternalVideo.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @video }
    end
  end

  def update
    @video = ExternalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_external_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Changes: ' + params.inspect)
    else
      @video.update_attributes(changes)
      logger.info("Updating these fields: #{changes.inspect}")
      if @video.save
        redirect_to(edit_external_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_external_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
      end
    end
  end

  def changed_fields(params)
    changes = Hash.new
    return changes if params[:document_fields].nil?
    video = ExternalVideo.find(params[:id])
    params[:document_fields].each do |k,v|
      unless video.send(k.to_sym) == v or (video.send(k.to_sym).empty? and v.first.empty?) or (v.sort.uniq.count > video.send(k.to_sym).count and v.sort.uniq.first.empty?)
        changes.store(k,v)
      end
    end
    return changes
  end

end
