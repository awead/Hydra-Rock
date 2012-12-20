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

  # Determins the image to be used for the icon in the index display
  def render_icon(document)
    unless document.fetch(:has_model_s,nil).nil?
      path = "rockhall/" + document.fetch(:has_model_s,nil).first.split(/:/).last.underscore + ".png"
      image_tag(path, :size=>"30x30")
    end
  end

  def contributor_display response, results = Array.new
    response[:document][response[:field]].each_index do |i|
      role = response[:document]["contributor_role_display"][i]
      if role
        results << response[:document][response[:field]][i] + " (" + role + ")"
      else
        results << response[:document][response[:field]][i]
      end
    end
    return results.join("<br/>").html_safe
  end
    
end
