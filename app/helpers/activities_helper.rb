module ActivitiesHelper

  # Helper methods for displaying information related to PublicActivity::Activities

  def render_activity_icon action
    case
      when action.match("create") then content_tag( :i, nil, :class => "icon-file").html_safe
      when action.match("update") then content_tag( :i, nil, :class => "icon-pencil").html_safe
      when action.match("delete") then content_tag( :i, nil, :class => "icon-trash").html_safe        
      else "unknown"
    end
  end

  def render_activity_message parameters, results = String.new
    case
    when parameters["action"].match("create")
      results << "created a new video, " + render_activity_link(parameters["title"], parameters["pid"])
    when parameters["action"].match("delete")
      results << "deleted video #{parameters["title"]}"
    when parameters["action"].match("update")
      results << "updated " + render_activity_link(parameters["title"], parameters["pid"])
      results << render_activity_changes(parameters["changes"])
    else
      results << "some other kind of activity"
    end
    return results.html_safe
  end

  def render_activity_link title, pid
    if ActiveFedora::Base.exists?(pid) && !pid.nil?
      link_to(title, catalog_path(pid))
    else
      title + ", but it has since been deleted"
    end
  end

  def render_activity_changes changes, results = String.new
    results << '<dl class="dl-horizontal dl-invert">'
    changes.each_key do |field|
      results << "<dt>"+field.gsub(/_/," ").titleize+"</dt>"
      results << "<dd>"+changes[field].join("<br/>")+"</dd>"
    end
    results << "</dl>"
    return results.html_safe
  end

end