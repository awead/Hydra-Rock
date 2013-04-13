module WorkflowHelper

  def render_submission_workflow_step
    if params["wf_step"]
      if params["wf_step"].match("permissions")
        render :partial => "shared/edit/permissions"
      else
        render :partial => "#{params["controller"]}/edit/#{params["wf_step"]}" rescue render :partial => "#{params["controller"]}/edit/titles"
      end
    else
      render :partial => "#{params["controller"]}/edit/titles"
    end
  end

  # navigation links to the other edit partials
  def workflow_dropdown results = String.new

    steps = [
      "titles",
      "subjects",
      "persons",
      "collections",
      "rockhall",
      "permissions" ]

    results << '<li class="dropdown">'
    results << '<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-pencil"></i> Edit <b class="caret"></b></a>'
    results << '<ul class="dropdown-menu">'
    steps.each do |step|
      if params[:wf_step] == step and params[:action] == "edit"
        results << "<li class=\"active\">"
        results << content_tag(:a, step.capitalize) 
      else
        results << "<li>"
        results << link_to(step.capitalize, edit_archival_video_path+"/"+step)
      end
      results<< "</li>"
    end

    results << "</ul>"
    return results.html_safe
  end

end