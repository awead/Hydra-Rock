module RockhallNavbarHelper

  # collection of items to be rendered in the @navbar
  def navbar_items
    @navbar_items ||= []
  end

  def render_add_assets
    render :partial=>"shared/navbar_partials/add_assets_links" if allow_asset_creation
  end

  # navbar items if a user is logged in
  def render_user_navbar(model, opts={})
    result = "<li>"
    result << link_to('<i class="icon-share"></i> Pbcore </a>'.html_safe, 
                       catalog_path(params[:id], :format => 'xml'), { :target => "_blank" })
    result << "</li>"
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
        else
          result << workflow_dropdown
        end
      end
      unless opts[:delete].nil?
        result << "<li>"
        result << button_to('Delete', archival_video_path(params[:id]),
                  :class => "btn-small btn-danger", :form => { :class=>"navbar-search"},
                  :confirm => 'Are you sure?', :method => :delete)
        result << "</li>"
      end
    end
    return result.html_safe
  end

  # deprecated
  def add_dropdown
    results = String.new
    results << '<li class="dropdown">'
    results << '<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-plus"></i> Add <b class="caret"></b></a>'
    results << '<ul class="dropdown-menu">'
    ["contributor","publisher"].each do |type|
      results << '<li>'
      results << link_to(type.capitalize, new_pbcore_node_path(params.merge!({:node=>type})))
      results << '</li>'
    end
    results << '</ul>'
    results << '</li>'
    return nil
  end

end