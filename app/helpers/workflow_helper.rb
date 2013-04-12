module WorkflowHelper

  def render_submission_workflow_step
    if params["step"]
      render :partial => "#{params["controller"]}/edit/#{params["step"]}" rescue render :partial => "#{params["controller"]}/edit/titles"
    else
      render :partial => "#{params["controller"]}/edit/titles"
    end
  end

end