class ArchivalVideosController < ApplicationController
  include Hydra::Controller
  include Hydra::AssetsControllerHelper  # This is to get apply_depositor_metadata method

  def edit
    @video = ArchivalVideo.find(params[:id])
  end

  def update
    @video = ArchivalVideo.find(params[:id])
    if @video.update_attributes(params[:archival_video])
      #
    else
      redirect_to edit_archival_video_path
    end
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