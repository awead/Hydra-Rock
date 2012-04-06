module VideoPlayerHelper


  def render_video_player
    if RH_CONFIG["video_player"].nil?
      render :partial => "video_player/jw_player"
    else
      render :partial => "video_player/#{RH_CONFIG["video_player"]}"
    end
  end


  def display_all_assets
    results = String.new
    videos = @document_fedora.videos
    videos.keys.each do |type|
      count = 1
      unless @document_fedora.videos[type].empty?
        @document_fedora.videos[type].each do |video|
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
    videos = @document_fedora.videos
    count = 1
    unless @document_fedora.videos[:h264].empty?
      @document_fedora.videos[:h264].each do |video|
        path = File.join(@document_fedora.pid.gsub(/:/,"_"),"data",video.name)
        results << "{title: 'Part #{count.to_s}', url: 'mp4:#{path}'}"
        count = count + 1
      end
    end
    return results.join(",").to_s
  end

end