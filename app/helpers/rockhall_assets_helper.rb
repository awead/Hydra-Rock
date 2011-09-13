module RockhallAssetsHelper

  # Render a link to delete the given asset from the repository.
  # Includes a confirmation message.
  def delete_object_link(pid, asset_type_display="asset")
    result = ""
    result << "<a href=\"\#delete_dialog\" class=\"inline\">Delete this #{asset_type_display}</a>"
    result << '<div style="display:none"><div id="delete_dialog">'
      result << "<p>Do you want to permanently delete this object from the repository?</p>"
      result << form_tag(url_for(:action => "destroy", :controller => "objects", :id => pid, :method => "delete"))
      result << hidden_field_tag("_method", "delete")
      result << submit_tag("Yes, delete")
      result << "</form>"
    result << '</div></div>'

    return result
  end

  def delete_image_link(pid, asset_type_display="asset")
    result = ""
    result << "<a href=\"\#delete_dialog\" class=\"inline\">Delete this #{asset_type_display}</a>"
    result << '<div style="display:none"><div id="delete_dialog">'
      result << "<p>Do you want to permanently delete this image from the repository?</p>"
      result << form_tag(url_for(:action => "destroy", :controller => "generic_content_objects", :id => pid, :method => "delete"))
      result << hidden_field_tag("_method", "delete")
      result << submit_tag("Yes, delete")
      result << "</form>"
    result << '</div></div>'

    return result
  end

  def display_field(path,opts={})
    opts[:datastream].nil? ? datastream = "descMetadata" : datastream = opts[:datastream]
    # Skip if there's no data in the field
    if get_values_from_datastream(@document_fedora, datastream, path).first.empty? and params[:action] == "show"
      return nil
    end

    if opts[:name].nil?
      field = fedora_field_label(datastream, path, path.first.to_s.capitalize)
    else
      field = fedora_field_label(datastream, path, opts[:name])
    end

    if params[:action] == "edit"
      if opts[:style]
        values = fedora_text_area(@document_fedora, datastream, path, :multiple=>false)
      else
        values = fedora_text_field(@document_fedora, datastream, path, :multiple=>false)
      end
    else
      values = get_values_from_datastream(@document_fedora, datastream, path)
    end
    result = String.new

    values.each do |value|
      if opts[:inline]
        result << "<li class=\"field\">" + field + value + "</li>"
      else
        result << "<dt>#{field}:</dt>"
        result << "<dd class=\"field\">#{value}</dd>"
      end
    end
    return result.html_safe
  end

  def display_legend(path,opts={})
    result = String.new
    unless get_values_from_datastream(@document_fedora,"descMetadata", path).first.empty?
      if opts[:name].nil?
        result = "<legend>" + path.first.to_s.capitalize + "</legend>"
      else
        result = "<legend>" + opts[:name] + "</legend>"
      end
    end
    return result
  end

  def asset_link(type)
    @document_fedora.external_video(type.to_sym).datastreams_in_memory["EXTERNALCONTENT1"].label
  end

  def display_all_assets
    results = String.new
    ["access_hq", "access_lq", "preservation"].each do |type|
      unless @document_fedora.external_video(type.to_sym).nil?
        results << "<dt>" + type.to_s + "</dt>"
        results << "<dd>" + link_to("File information", catalog_path(@document_fedora.external_video(type.to_sym).pid)) + "</dd>"
      end
    end
    return results
  end

  def add_field_button(type,content_type,opts={})
    results = String.new
    results << "<input id=\"content_type\" type=\"hidden\" name=\"#{content_type}\" value=\"#{content_type}\"/>"
    results << "<div class=\"add-rh-pbcore-box\">"
    results << "<input id=\"add-rh-pbcore-action\" type=\"button\" title=\"button title\" value=\"Add #{type.to_s}\" />"
    results << "</div>"
    return results.html_safe
  end

  def display_multiple_field(type,opts={})
    collection = @document_fedora.datastreams_in_memory["descMetadata"].find_by_terms(type)
    if opts[:edit]
      render :partial=>"pbcore/edit/#{type.to_s}", :collection=>collection
    else
      render :partial=>"pbcore/show/#{type.to_s}", :collection=>collection
    end
  end

end
