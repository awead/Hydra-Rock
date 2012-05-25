class ArchivalVideosController < ApplicationController
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method

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
      redirect_to(@video, :notice => 'No changes saved')
    else
      @video.update_attributes(changes)
      if @video.save
        redirect_to(@video, :notice => 'Video was updated successfully')
      else
        redirect_to(@video, :notice => 'Error: Unable to save changes')
      end
    end
  end

  def changed_fields(params)
    changes = Hash.new
    video = ArchivalVideo.find(params[:id])
    params[:archival_video].each do |k,v|
      unless video.send(k.to_sym) == v or (video.send(k.to_sym).empty? and v.first.empty?) or (v.sort.uniq.count > video.send(k.to_sym).count and v.sort.uniq.first.empty?)
        changes.store(k,v)
      end
    end
    return changes
  end

end