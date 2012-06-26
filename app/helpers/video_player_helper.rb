module VideoPlayerHelper

  # define a player column that we can display when needed
  def player_column
    @player_column ||= []
  end

  # Displays the video player using the catalog controller
  def render_video_player_in_catalog(opts={})
    @afdoc = ActiveFedora::Base.load_instance_from_solr(params[:id])
    render_video_player
  end

  # Displays the video player using a Hydra controller
  def render_video_player(opts={})
    if @afdoc.file_objects.count > 0
      if RH_CONFIG["video_player"].nil?
        render :partial => "video_player/jw_player"
      else
        render :partial => "video_player/#{RH_CONFIG["video_player"]}"
      end
    else
      render :partial => "video_player/unavailable"
    end
  end

  def display_all_assets
    results = String.new
    videos = @afdoc.videos
    videos.keys.each do |type|
      count = 1
      unless @afdoc.videos[type].empty?
        @afdoc.videos[type].each do |video|
          results << "<dt><label for=\"#{type.to_s}_#{count.to_s}\">#{type.to_s} part #{count.to_s}</label></dt>"
          results << "<dd>" + link_to("File information", catalog_path(video.pid)) + "</dd>"
          count = count + 1
        end
      end
    end
    return results.html_safe
  end

  def flowplayer_playlist
    results = Array.new
    videos = @afdoc.videos
    count = 1
    unless @afdoc.videos[:h264].empty?
      @afdoc.videos[:h264].each do |video|
        path = File.join(@afdoc.pid.gsub(/:/,"_"),"data",video.name)
        results << "{title: 'Part #{count.to_s}', url: 'mp4:#{path}'}"
        count = count + 1
      end
    end
    return results.join(",").to_s
  end

end