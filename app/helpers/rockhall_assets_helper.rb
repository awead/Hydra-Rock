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

  def display_field(path,opts={})

    # Default to descMetadata
    opts[:datastream].nil? ? datastream = "descMetadata" : datastream = opts[:datastream]

    # Skip if there's no data in the field
    if get_values_from_datastream(@document_fedora, datastream, path).first.empty? and params[:action] == "show"
      return nil
    end

    # Determine field label
    if opts[:name].nil?
      field = fedora_field_label(datastream, path, path.first.to_s.capitalize)
    else
      field = fedora_field_label(datastream, path, opts[:name])
    end

    # Show or edit
    if params[:action] == "edit"
      if opts[:area]
        values = fedora_text_area(@document_fedora, datastream, path)
      else
        values = fedora_text_field(@document_fedora, datastream, path, :multiple=>opts[:multiple], :hidden=>opts[:hidden])
      end
    else
      values = get_values_from_datastream(@document_fedora, datastream, path)
    end

    # Put it all together
    result = String.new
    values.each do |value|
      if opts[:inline]
        result << "<li class=\"field\">" + field + value + "</li>"
      elsif opts[:area]
        result << value
      else
        result << "<dt>#{field}:</dt>" unless opts[:hidden]
        result << "<dd class=\"field\">#{value}</dd>"
      end
    end

    if opts[:area]
      return field.html_safe + result.html_safe
    else
      return result.html_safe
    end
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
    @document_fedora.external_video(type.to_sym).datastreams_in_memory["ACCESS1"].label
  end

  def display_all_assets
    results = String.new
    videos = @document_fedora.videos
    videos.keys.each do |type|
      unless @document_fedora.videos[type].empty?
        results << "<dt>" + type.to_s + "</dt>"
        results << "<dd>" + link_to("File information", catalog_path(@document_fedora.videos[type])) + "</dd>"
      end
    end
    return results.html_safe
  end

  def add_field_button(type,content_type,opts={})
    results = String.new

    # WIth AJAX:
    #results << "<input id=\"content_type\" type=\"hidden\" name=\"#{content_type}\" value=\"#{content_type}\"/>"
    #results << "<div class=\"add-rh-pbcore-box\">"
    #results << "<input id=\"add-rh-pbcore-action\" type=\"button\" title=\"button title\" value=\"Add #{type.to_s}\" />"
    #results << "</div>"

    # Plain ol' HTML

    return results.html_safe
  end

  def delete_field_button
    results = String.new

    ["contributor","publisher","genre","topic","series"].each do |type|
      # Note: we have to call the datastream method directly otherwise the helper method returns 1
      types = @document_fedora.get_values_from_datastream('descMetadata', [type.to_sym]).length
      if types > 0
        index = 0
        while index < types
          if type.include?("genre") or type.include?("topic")
            value = get_values_from_datastream(@document_fedora,'descMetadata', [{type.to_sym=>"#{index.to_s}"}]).first
          else
            value = get_values_from_datastream(@document_fedora,'descMetadata', [{type.to_sym=>"#{index.to_s}"}, :name]).first
          end
          name = value.empty? ? " #" + (index + 1).to_s : " " + value
          results << button_to("Delete " + type + name,
          {:action=>"destroy", :asset_id=>@document[:id], :controller=>"pbcore", :content_type=>"archival_video", :node=>type, :index=>index},
          :method => :delete)
          index = index + 1
        end
      end
    end

    return results.html_safe
  end


  def display_fieldset(type,opts={})
    collection = @document_fedora.datastreams_in_memory["descMetadata"].find_by_terms(type)
    if opts[:edit]
      render :partial=>"pbcore/edit/#{type.to_s}", :collection=>collection
    else
      render :partial=>"pbcore/show/#{type.to_s}", :collection=>collection
    end
  end


  def contributor_select(node)
    results = String.new
    results << "<select class=\"contributor_select\" name=\"contributor_select_#{node.to_s}\" id=\"contributor_select_#{node.to_s}\" onchange=\"updateContributor('#{node.to_s}')\">"
    results << "<option value=\"\"></option>"
    Relators.marc.each do |k, v|
      if get_values_from_datastream(@document_fedora,'descMetadata', [{:contributor=>node}, :role]).first == k
        results << "<option value=\"#{v}\" selected>#{k}</option>"
      else
        results << "<option value=\"#{v}\">#{k}</option>"
      end
    end
    results << "</select>"
    return results.html_safe
  end

  def publisher_select(node)
    results = String.new
    results << "<select class=\"publisher_select\" name=\"publisher_select_#{node.to_s}\" id=\"publisher_select_#{node.to_s}\" onchange=\"updatePublisher('#{node.to_s}')\">"
    results << "<option value=\"\"></option>"
    Relators.pbcore.each do |k, v|
      if get_values_from_datastream(@document_fedora,'descMetadata', [{:publisher=>node}, :role]).first == k
        results << "<option value=\"#{v}\" selected>#{k}</option>"
      else
        results << "<option value=\"#{v}\">#{k}</option>"
      end
    end
    results << "</select>"
    return results.html_safe
  end

end
