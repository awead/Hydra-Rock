module RockhallDisplayHelper

  def display_field field,opts={}, results = String.new
    return nil if @document[field.to_sym].nil? or @document[field.to_sym].first.empty?
    
    # Determine field label
    if opts[:name].nil?
      parts = field.to_s.split(/_/)
      parts.pop
      name = parts.each{|word| word.capitalize!}.join(" ")
      @document[field.to_sym].count > 1 ? formatted_name = name.pluralize : formatted_name = name
    else
      formatted_name = opts[:name]
    end
    results << "<dt class=\"#{field.to_s}\">" + formatted_name + "</dt>"
    @document[field.to_sym].each do |v|
      results << "<dd class=\"#{field.to_s}\">" + v + "</dd>"
    end
    return results.html_safe
  end

  def display_tabular_field field, heading, results = String.new
    return nil if field.first.blank?

    # Determine field label
    parts = heading.to_s.split(/_/)
    name = parts.each{|word| word.capitalize!}.join("&nbsp;")
    formatted_name = field.count > 1 ? formatted_name = name.pluralize : formatted_name = name
    results << "<tr><th class=\"#{heading.downcase}\">" + formatted_name + "</th>"
    results << "<td class=\"#{heading.downcase}\">" + field.join("<br/>") + "</td></tr>"
    return results.html_safe

  end

  # Determines the image to be used for the icon in the index display
  def render_icon(document)
    object = ActiveFedora::Base.load_instance_from_solr(document.id)
    case object.class.to_s
    when "ExternalVideo"
      object.instantiation_type.nil? ? "unknown" : image_tag(("rockhall/"+object.instantiation_type+"_instantiation.png"), :class => "thumbnail")
    else
      image_tag(("rockhall/" + object.class.to_s.underscore + ".png"), :class => "thumbnail")
    end
  end

  def render_title_for_index_view document
    if document["generation_display"].nil?
      document["title_display"]
    else
      document["parent_title_display"].nil? ? document["generation_display"].first : document["parent_title_display"].first + " >> " + document["generation_display"].first
    end  
  end

  def contributor_display response, results = Array.new
    response[:document][response[:field]].each_index do |i|
      role = response[:document]["contributor_role_display"][i] unless response[:document]["contributor_role_display"].nil?
      if role
        results << response[:document][response[:field]][i] + " (" + role + ")"
      else
        results << response[:document][response[:field]][i]
      end
    end
    return results.join("<br/>").html_safe
  end
    
  def render_tech_info_button type, index
    link_text = type.to_s.capitalize + " (" + (index + 1).to_s + ")" + '<i class="icon-chevron-down"></i>'
    link_to(link_text.html_safe, external_video_path(@afdoc.videos[type][index].pid), :class => "show_tech_info")
  end

  def render_file_list
    unless @afdoc.external_videos.empty?
      render :partial => "external_videos/show/list" if current_user
    end
  end

  def is_reviewed? document
    document.fetch(:complete_facet,nil).nil? ? "n/a" : document.fetch(:complete_facet,nil).first
  end

  def render_import_button
    if params["action"].match("edit")
      link_to("Import", import_archival_video_path, :id => "import_video_modal", :class => "btn btn-info more_facets_link")
    end
  end

  def render_adder_button key
    content_tag(:button, ('<i class="icon-plus icon-white"></i>').html_safe, 
                :id => "additional_#{key}", :class => "adder btn-info btn-mini")
  end

  def render_remover_button key
    content_tag(:button, ('<i class="icon-minus icon-white"></i>').html_safe, :class => "remover btn-danger btn-mini")
  end

  def render_add_nodes_button key
    link_to('<i class="icon-plus icon-white"></i>'.html_safe, new_node_path(params[:id], key), :id => "open_event_modal", :class => "btn btn-info btn-mini more_facets_link").html_safe
  end

  def render_remove_nodes_button key, index
    js_class = key.match(/event/) ? "delete_events" : "delete_" + key + "s"
    link_to('<i class="icon-minus icon-white"></i>'.html_safe, node_path(params[:id], key, index), :class => "btn btn-mini btn-danger #{js_class}").html_safe
  end

end