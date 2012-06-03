module RockhallNavbarHelper

  # collection of items to be rendered in the @navbar
  def navbar_items
    @navbar_items ||= []
  end

  # navbar items if a user is logged in
  def render_user_navbar
    result = String.new
    if current_user
      if params[:action] == "edit"
        result << "<li>"
        result << '<a href="' + url_for(archival_video_path(params[:id])) + '"> <i class="icon-eye-open"></i> View </a>'
        result << "</li>"
      else
        result << workflow_dropdown("archival_videos")
      end
      result << "<li>"
      result << button_to('Delete', archival_video_path(params[:id]),
                :class => "btn-small btn-danger", :form => { :class=>"navbar-search"},
                :confirm => 'Are you sure?', :method => :delete)
      result << "</li>"
    end
    return result.html_safe
  end

  # navigation links to the other edit partials
  def workflow_dropdown(model)
    steps = Array.new
    Hydra.config[:submission_workflow][model.to_sym].each { |x| steps << x[:name] }
    params[:wf_step] = "titles" if params[:wf_step].nil?

    results = String.new
    results << '<li class="dropdown">'
    results << '<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-pencil"></i> Edit <b class="caret"></b></a>'
    results << '<ul class="dropdown-menu">'
    steps.each do |step|
      if params[:wf_step] == step and params[:action] == "edit"
        results << "<li class=\"active\">"
      else
        results << "<li>"
      end
      results << "<a href=\"" + url_for(edit_archival_video_path(:wf_step=>step)) + "\">" + step.capitalize + "</a>"
      results<< "</li>"
    end
    results << "</ul>"
    return results.html_safe
  end

  def add_dropdown
    results = String.new
    results << '<li class="dropdown">'
    results << '<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-plus"></i> Add <b class="caret"></b></a>'
    results << '<ul class="dropdown-menu">'
    ["contributor","publisher"].each do |type|
      results << '<li>'
      results << link_to(type.capitalize, new_pbcore_node_path(params.merge!({:node=>type})), :remote=>true)
      results << '</li>'
    end
    results << '</ul>'
    results << '</li>'
    return results.html_safe
  end

end