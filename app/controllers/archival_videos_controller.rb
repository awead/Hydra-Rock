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
    #@video = ArchivalVideo.find(params[:id])
    #if @video.update_attributes(params[:archival_video])
      #
    #else
    #  redirect_to edit_archival_video_path
    #end
    # dirty = FALSE
    #params[:archival_video].each do |k,v|
    #  unless params[:archival_video][k.to_sym].first.empty? or params[:archival_video][k.to_sym] == @video.send(k).join
    #    @video.send("#{k}=".to_sym, v)
    #    dirty = TRUE
    #    logger.warn("\n\n\n\n\n\n\n\n\n I'M DIRTY!!!!!!!!!!!!!!!")
    #  end
    #end
    #@video.save if dirty
  end

end