module RockhallAssetsHelper

  include Hydra::AccessControlsEvaluation

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

    # Determine id
    if opts[:id]
      id = opts[:id]
    else
      id = path.flatten.to_s
    end

    # Show or edit
    if params[:action] == "edit"
      values = fedora_text_field(@document_fedora, datastream, path, :multiple=>opts[:multiple], :required=>opts[:required])
    else
      values = get_values_from_datastream(@document_fedora, datastream, path)
    end

    # Determine field label
    if opts[:name].nil?
      cap_name = path.first.to_s.split(/_/).each{|word| word.capitalize!}.join(" ")
      if params[:action] == "edit"
        formatted_name = cap_name
      else
        values.count > 1 ? formatted_name = cap_name.pluralize : formatted_name = cap_name
      end
    else
      if params[:action] == "edit"
        formatted_name = opts[:name]
      else
        values.count > 1 ? formatted_name = opts[:name].pluralize : formatted_name = opts[:name]
      end
    end
    field = fedora_field_label(datastream, path, formatted_name)

    # Put it all together
    result = String.new
    if params[:action] == "edit"
      result << "<p id=\"#{id}\" class=\"fedora-text-field\">" + field unless opts[:hidden]
      result << values
    else
      result << "<dt id=\"#{id}\">" + formatted_name + "</dt>"
      result << "<dd id=\"#{id}\" class=\"field\"><ul>"
      values.each do |value|
        result << "<li>" + value + "</li>"
      end
      result << "</ul></dd>"
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
    @document_fedora.external_video(type.to_sym).datastreams["ACCESS1"].label
  end

  # Only used with jw_player
  def video_asset_path(type)
    path = String.new
    unless @document_fedora.external_video(:h264).first.nil?
      filename = @document_fedora.external_video(:h264).first.datastreams["descMetadata"].get_values(:name)
      path = File.join(@document_fedora.pid.gsub(/:/,"_"),"data",filename)
    end
    return path
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
    results << "<ul>"
    ["contributor","publisher"].each do |type|
      # Note: we have to call the datastream method directly otherwise the helper method returns 1
      types = @document_fedora.get_values_from_datastream('descMetadata', [type.to_sym]).length
      if types > 0
        results << "<li> Delete " + pluralize(types, type) + "</li>"
        index = 0
        while index < types
          if type.include?("genre") or type.include?("topic")
            value = get_values_from_datastream(@document_fedora,'descMetadata', [{type.to_sym=>"#{index.to_s}"}]).first
          else
            value = get_values_from_datastream(@document_fedora,'descMetadata', [{type.to_sym=>"#{index.to_s}"}, :name]).first
          end
          name = value.empty? ? " #" + (index + 1).to_s : " " + value
          results << "<li>"
          results << button_to(("Delete " + name.strip).truncate(28),
                      {:action=>"destroy", :asset_id=>@document[:id], :controller=>"pbcore", :content_type=>"archival_video", :node=>type, :index=>index, :wf_step=>params[:wf_step]},
                      :method => :delete)
          results << "</li>"
          index = index + 1
        end
      end
    end
    results << "</ul>"
    return results.html_safe
  end


  def display_fieldset(type,opts={})
    collection = @document_fedora.datastreams["descMetadata"].find_by_terms(type)
    render :partial=>"pbcore/#{type.to_s}", :collection=>collection
  end


  def toc_links
    results = String.new
    results << "<ul>"
    results << "<li><a href=\"#\">Top</a></li>"
    ["content","original","digital","rockhall","permissions"].each do |anchor|
      if params[:action] == "edit"
        results << "<li>" + link_to(anchor.capitalize, edit_catalog_path(@document_fedora, :anchor=>anchor)) + "</li>"
      else
        results << "<li>" + link_to(anchor.capitalize, catalog_path(@document_fedora, :anchor=>anchor)) + "</li>"
      end
    end
    results << "</ul>"
    return results.html_safe
  end


  def contributor_link(counter)
    result = String.new
    role = get_values_from_datastream(@document_fedora, "descMetadata", [{:contributor=>counter}, :role])
    unless role.first.blank?
      result = ", " + role.to_s
    end
    return result.to_s
  end


  def publisher_link(counter)
    result = String.new
    role = get_values_from_datastream(@document_fedora, "descMetadata", [{:publisher=>counter}, :role])
    unless role.first.blank?
      result = ", " + role.to_s
    end
    return result.to_s
  end

  def get_review_status(document)
    results = String.new
    if document[:complete_t].nil?
      results << "no"
    else
      results << document[:complete_t].first
    end
    return results.html_safe
  end

  def allow_asset_creation
    unless current_user.nil?
      user_groups = RoleMapper.roles(current_user.login)
      if user_groups.include?("archivist") or user_groups.include?("reviewer")
        return TRUE
      end
    end
  end

  def list_available_assets_to_create
    results = String.new
    results << "<li>"
    results << link_to_create_asset('Add archival video', 'archival_video')
    results << "</li>"
    results << "<li>"
    results << link_to_create_asset('Add digital video', 'digital_video')
    results << "</li>"
    user_groups = RoleMapper.roles(current_user.login)
    if user_groups.include?("archivist")
      results << "<li>"
      results << link_to_create_asset('Add a Basic MODS Asset', 'mods_asset')
      results << "</li>"
      results << "<li>"
      results << link_to_create_asset('Add an Image', 'generic_image')
      results << "</li>"
      results << "<li>"
      results << link_to_create_asset('Add Generic Content', 'generic_content')
      results << "</li>"
    end
    return results.html_safe
  end

  def get_video_asset_count(document)
    return "todo..."
  end

end
