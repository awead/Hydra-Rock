module VideoPlayerHelper

  # define a player column that we can display when needed
  def player_column
    @player_column ||= []
  end

  # Displays the video player using a Hydra controller
  def render_video_player opts={}
    if @afdoc.videos[:access].count > 0
      if RH_CONFIG["video_player"].nil?
        render :partial => "video_player/jw_player"
      else
        render :partial => "video_player/#{RH_CONFIG["video_player"]}"
      end
    else
      render :partial => "video_player/unavailable"
    end
  end

  def display_all_assets results = String.new
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

  def flowplayer_playlist results = String.new
    if @afdoc.videos[:access].count > 1
      @afdoc.external_video(:h264).each do |ds|
        results << link_to("", ds.datastreams["ACCESS1"].label)
      end      
    end  
    return results.html_safe
  end

end