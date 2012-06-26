module RockhallDisplayHelper

  def display_field(field,opts={})
    results = String.new
    return nil if @document[field.to_sym].nil? or @document[field.to_sym].first.empty?
    # Determine field label
    if opts[:name].nil?
      name = field.to_s.gsub(/_t$/,"").split(/_/).each{|word| word.capitalize!}.join(" ")
      @document[field.to_sym].count > 1 ? formatted_name = name.pluralize : formatted_name = name
    else
      formatted_name = opts[:name]
    end
    results << "<dt id=\"#{field.to_s}\">" + formatted_name + "</dt>"
    @document[field.to_sym].each do |v|
      results << "<dd id=\"#{field.to_s}\">" + v + "</dd>"
    end
    return results.html_safe
  end

  def get_review_status_from_solr_doc(document)
    results = String.new
    if document[:complete_t].nil?
      results << "no"
    else
      results << document[:complete_t].first
    end
    return results.html_safe
  end

  def get_heading_display_from_solr_doc(document)
    if document[blacklight_config.index.show_link].nil?
      return document[:id]
    else
      return document[blacklight_config.index.show_link].first
    end
  end

end
