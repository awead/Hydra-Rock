module RockhallAssetsHelper

  include Hydra::AccessControlsEvaluation

  def asset_link(type)
    @document_fedora.external_video(type.to_sym).datastreams["ACCESS1"].label
  end

  # Only used with jw_player
  def video_asset_path(type)
    path = String.new
    unless @document_fedora.external_video(:h264).first.nil?
      filename = @document_fedora.external_video(:h264).first.datastreams["descMetadata"].get_values(:name)
      path = File.join(@document_fedora.pid.gsub(/:/,"_"),"data",filename)
    end
    return path
  end

  def allow_asset_creation
    unless current_user.nil?
      user_groups = RoleMapper.roles(current_user.login)
      if user_groups.include?("archivist") or user_groups.include?("reviewer")
        return TRUE
      end
    end
  end

  def list_available_assets_to_create
    results = String.new
    results << "<li>"
    results << link_to('Archival Video', new_archival_video_path)
    results << "</li>"
    results << "<li>"
    results << link_to_create_asset('Digital Video', 'digital_video')
    results << "</li>"
    user_groups = RoleMapper.roles(current_user.login)
    if user_groups.include?("archivist")
      results << "<li>"
      results << link_to_create_asset('Basic MODS Asset', 'mods_asset')
      results << "</li>"
      results << "<li>"
      results << link_to_create_asset('Image', 'generic_image')
      results << "</li>"
      results << "<li>"
      results << link_to_create_asset('Generic Content', 'generic_content')
      results << "</li>"
    end
    return results.html_safe
  end

end
