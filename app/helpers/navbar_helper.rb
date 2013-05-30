module NavbarHelper

  # collection of items to be rendered in the @navbar
  def navbar_items
    @navbar_items ||= []
  end

  def render_add_assets
    render :partial=>"shared/navbar_partials/add_assets_links" if allow_asset_creation
  end

  # navbar items if a user is logged in
  def render_user_navbar model, opts={}, result = String.new
    result << content_tag(:li, render_export_dropdown)
    if current_user
      if params[:action] == "edit"
        result << "<li>"
        result << link_to('<i class="icon-eye-open"></i> View </a>'.html_safe, catalog_path(params[:id]))
        result << "</li>"
      else
        if RoleMapper.roles(current_user.email).include?("reviewer")
          result << "<li>"
          result << link_to_edit_asset('<i class="icon-pencil"></i> Edit </a>'.html_safe, model)
          result << "</li>"
        end 
        if RoleMapper.roles(current_user.email).include?("archivist")
          result << workflow_dropdown
        end
      end
    end
    return result.html_safe
  end

  # display flash message in the navbar
  def render_navbar_flash_message results = String.new
    flash.keys.each do |message|
      results << content_tag(:div, render_error_message(flash[message]), :class => "alert " + render_alert_class )
    end
    return results.html_safe
  end

  def render_export_dropdown
    render :partial => "shared/navbar_partials/export_links"
  end

  # if this is an error message, display accordingly, otherwise just return the message
  def render_error_message message
    message.is_a?(ActiveSupport::OrderedHash) ? message.values.flatten.compact.join("<br/>") : message
  end

  # determine class based on the flash key
  def render_alert_class
    flash.keys.first == :notice ? "alert-info" : "alert-"+flash.keys.first.to_s
  end

end