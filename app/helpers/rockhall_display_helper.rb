module RockhallDisplayHelper

  # collection of items to be rendered in the @navbar
  def navbar_items
    @navbar_items ||= []
  end

  # edit and view links for items
  def edit_and_show_links
    result = String.new
    if current_user
      result << "<li>"
      if params[:action] == "edit"
        #result << "<i class=\"icon-eye-open\"></i> "
        result << link_to("View", archival_video_path(params[:id]))
      else
        #result << "<i class=\"icon-edit\"></i> "
        result << link_to("Edit", edit_archival_video_path(params[:id]))
      end
      result << "</li>"
    end
    return result.html_safe
  end




end