module RockhallNavbarHelper

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

  # navigation links to the other edit partials
  def workflow_dropdown(model)
    steps = Array.new
    Hydra.config[:submission_workflow][model.to_sym].each { |x| steps << x[:name] }
    params[:wf_step] = "titles" if params[:wf_step].nil?

    results = String.new
    results << '<li class="dropdown">'
    results << '<a href="#" class="dropdown-toggle" data-toggle="dropdown"> Available workflow steps <b class="caret"></b></a>'
    results << '<ul class="dropdown-menu">'
    steps.each do |step|
      if params[:wf_step] == step
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


end