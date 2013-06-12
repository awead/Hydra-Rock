module NavbarHelper

  # collection of items to be rendered in the @navbar
  def navbar_items
    @navbar_items ||= []
  end

  def render_view_button
    content_tag(:li, link_to('<i class="icon-eye-open"></i> View </a>'.html_safe, catalog_path(params[:id]))) if params[:action] == "edit"
  end

  def render_workflow_menu
    unless current_user.nil?
      workflow_dropdown if RoleMapper.roles(current_user.email).include?("archivist")
    end
  end

  # display flash message in the navbar
  def render_navbar_flash_message results = String.new
    flash.keys.each do |message|
      results << content_tag(:div, render_error_message(flash[message]), :class => "alert " + render_alert_class )
    end
    return results.html_safe
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