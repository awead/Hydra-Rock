class ArchivalVideosController < ApplicationController
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method

  before_filter :enforce_access_controls

  def edit
    @video = ArchivalVideo.find(params[:id])
    respond_to do |format|
      format.html  # edit.html.erb
      format.json  { render :json => @video }
    end
  end

  def new
    @video = ArchivalVideo.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @video }
    end
  end

  def show
    @video = ArchivalVideo.find(params[:id])
    respond_to do |format|
      format.html  # show.html.erb
      format.json  { render :json => @video }
    end
  end

  def create
    @video = ArchivalVideo.new(params[:archival_video])
    @video.apply_depositor_metadata(current_user.login)
    respond_to do |format|
      if @video.save
        format.html { redirect_to(@video, :notice => 'Post was successfully created.') }
        format.json { render :json => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.json { render :json => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @video = ArchivalVideo.find(params[:id])
    changes = changed_fields(params)
    if changes.empty?
      redirect_to(edit_archival_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'No changes saved')
    else
      @video.update_attributes(changes)
      logger.info("Updating these fields: #{changes.inspect}")
      if @video.save
        redirect_to(edit_archival_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Video was updated successfully')
      else
        redirect_to(edit_archival_video_path(@video, :wf_step=>params[:wf_step]), :notice => 'Error: Unable to save changes')
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

  def changed_fields(params)
    changes = Hash.new
    return changes if params[:archival_video].nil?
    video = ArchivalVideo.find(params[:id])
    params[:archival_video].each do |k,v|
      unless video.send(k.to_sym) == v or (video.send(k.to_sym).empty? and v.first.empty?) or (v.sort.uniq.count > video.send(k.to_sym).count and v.sort.uniq.first.empty?)
        changes.store(k,v)
      end
    end
    return changes
  end

end