module RockhallAssetsHelper

  include Hydra::AccessControlsEvaluation

  def asset_link(type)
    @afdoc.videos[type.to_sym].first.datastreams["ACCESS1"].label
  end

  # Only used with jw_player
  def video_asset_path(type)
    path = String.new
    unless @afdoc.external_video(:h264).first.nil?
      filename = @afdoc.external_video(:h264).first.datastreams["descMetadata"].get_values(:name)
      path = File.join(@afdoc.pid.gsub(/:/,"_"),"data",filename)
    end
    return path
  end

  def allow_asset_creation
    unless current_user.nil?
      user_groups = RoleMapper.roles(current_user.email)
      if user_groups.include?("archivist") or user_groups.include?("reviewer")
        return TRUE
      end
    end
  end

  def list_available_assets_to_create results = String.new
    results << content_tag(:li, link_to('Archival Video', new_archival_video_path))
    results << content_tag(:li, link_to('Digital Video', new_digital_video_path))
    return results.html_safe
  end

  def url_for_edit_asset(model,opts={})
    url_for(send(("edit_" + model.singularize + "_path"), opts))
  end

  def link_to_edit_asset(body,model,url_opts={},html={})
    result = String.new
    result << '<a href="' + url_for_edit_asset(model,url_opts) + '">'
    result << body
    result << '</a>'
  end

  def url_for_asset(model,opts={})
    url_for(send((model.singularize + "_path"), opts))
  end

  # Returns link for a given model
  def link_to_asset(body,model,url_opts={},html={})
    result = String.new
    result << '<a href="' + url_for_asset(model,url_opts) + '">'
    result << body
    result << '</a>'
  end

  # Returns link to the parent video from an external video object
  def url_for_parent_video
    model = @afdoc.part_of.first.class.to_s.underscore.pluralize
    pid   = @afdoc.part_of.first.pid
    return url_for_asset(model, {:id=>pid}).html_safe
  end


  # Used in catalog#index or anywhere else where we have a solr document, but we
  # don't know what the model of our asset is.
  # requires: hydra_assets_helper_behavior#document_type
  #
  # TODO: blackight_config is empty in archival_videos controller
  def url_for_asset_from_solr_doc(document,opts={})
    if document_type(document).empty?
      model = document[:has_model_s].first.gsub("info:fedora/afmodel:","").underscore
    else
      model = document_type(document).underscore
    end
    logger.info("get_asset_path_from_solr_doc = " + model)
    method = model + "_path"
    return send(method, document[:id]).html_safe
  end

  # Returns the url to download the access version of a video
  def link_to_access_video text = nil
    url = @afdoc.external_video(:h264).first.datastreams["ACCESS1"].label
    link_to(text, url, :class => "btn")

  end


end
