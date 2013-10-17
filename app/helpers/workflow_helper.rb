module WorkflowHelper

  def render_submission_workflow_step
    if params["wf_step"]
      if params["wf_step"].match("permissions")
        render :partial => "shared/edit/permissions"
      else
        render :partial => "#{params["controller"]}/edit/#{params["wf_step"]}"
      end
    else
      render :partial => "#{params["controller"]}/edit/titles"
    end
  end

  def render_delete_link
    link_to("Delete", archival_video_path(params[:id]), :data => { :confirm => "Are you sure?" }, :method => :delete)
  end

  # navigation links to the other edit partials
  def workflow_dropdown results = String.new

    steps = [
      "titles",
      "descriptions",
      "subjects",
      "persons",
      "collections",
      "review",
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

    unless @afdoc.external_videos.empty?
      results << content_tag(:li, nil, :class => "divider")
      results << content_tag(:li, "Videos", :class => "nav-header")
      results << render_external_video_workflow_steps
    end

    results << content_tag(:li, nil, :class => "divider")
    results << content_tag(:li, render_delete_link)

    results << "</ul>"
    return results.html_safe
  end

  def render_external_video_workflow_steps results = String.new
    @afdoc.videos.each_key do |type| 
      unless @afdoc.videos[type].empty? 
        @afdoc.videos[type].each_index do |index| 
          results << content_tag(:li, link_to(external_video_workflow_name(@afdoc.videos[type][index]), edit_external_video_path(@afdoc.videos[type][index].pid)))
        end
      end
    end
    return results
  end

  def external_video_workflow_name obj
    if obj.generation.nil? || obj.generation.empty?
      "Unknown generation"
    else
      obj.generation.first
    end
  end


end