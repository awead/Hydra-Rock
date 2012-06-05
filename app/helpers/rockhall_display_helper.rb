module RockhallDisplayHelper

  def display_field(field,opts={})
    results = String.new
    return nil if @video.send(field.to_sym).empty? or @video.send(field.to_sym).first.empty?
    # Determine field label
    if opts[:name].nil?
      cap_name = field.to_s.split(/_/).each{|word| word.capitalize!}.join(" ")
      @video.send(field.to_sym).count > 1 ? formatted_name = cap_name.pluralize : formatted_name = cap_name
    else
      @video.send(field.to_sym).count > 1 ? formatted_name = opts[:name].pluralize : formatted_name = opts[:name]
    end
    results << "<dt>" + formatted_name + "</dt>"
    @video.send(field.to_sym).each do |v|
      results << "<dd>" + v + "</dd>"
    end
    return results.html_safe
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

end
