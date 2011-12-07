module TechDataHelper

  def display_file_size
    field = String.new
    results = String.new
    if get_values_from_datastream(@document_fedora, "descMetadata", [:size]).first.empty?
      field << "unavailable"
    else
      field << get_values_from_datastream(@document_fedora, "descMetadata", [:size]).first
      unless get_values_from_datastream(@document_fedora, "descMetadata", [:size_units]).first.empty?
        units = get_values_from_datastream(@document_fedora, "descMetadata", [:size_units]).first
        field << " " + ["(", units, ")"].join
      end
    end
    results << "<dt><label for=\"video_bit_rate\">File Size</label></dt>"
    results << "<dd class=\"field\">#{field}</dd>"
    return results.html_safe

  end


  def display_video_bit_rate
    field = String.new
    results = String.new
    if get_values_from_datastream(@document_fedora, "descMetadata", [:video_bit_rate]).first.empty?
      field << "unavailable"
    else
      field << get_values_from_datastream(@document_fedora, "descMetadata", [:video_bit_rate]).first
      unless get_values_from_datastream(@document_fedora, "descMetadata", [:video_bit_rate_units]).first.empty?
        units = get_values_from_datastream(@document_fedora, "descMetadata", [:video_bit_rate_units]).first
        field << " " + ["(", units, ")"].join
      end
    end
    results << "<dt><label for=\"video_bit_rate\">Video Bit Rate</label></dt>"
    results << "<dd class=\"field\">#{field}</dd>"
    return results.html_safe
  end

  def display_video_frame_rate
    field = String.new
    results = String.new
    if get_values_from_datastream(@document_fedora, "descMetadata", [:frame_rate]).first.empty?
      field << "unavailable"
    else
      value = get_values_from_datastream(@document_fedora, "descMetadata", [:frame_rate]).first
      field << value + " (fps)"
    end
    results << "<dt><label for=\"video_bit_rate\">Video Frame Rate</label></dt>"
    results << "<dd class=\"field\">#{field}</dd>"
    return results.html_safe
  end

  def display_audio_bit_rate
    field = String.new
    results = String.new
    if get_values_from_datastream(@document_fedora, "descMetadata", [:audio_bit_rate]).first.empty?
      field << "unavailable"
    else
      field << get_values_from_datastream(@document_fedora, "descMetadata", [:audio_bit_rate]).first
      unless get_values_from_datastream(@document_fedora, "descMetadata", [:audio_bit_rate_units]).first.empty?
        units = get_values_from_datastream(@document_fedora, "descMetadata", [:audio_bit_rate_units]).first
        field << " " + ["(", units, ")"].join
      end
    end
    results << "<dt><label for=\"audio_bit_rate\">Audio Bit Rate</label></dt>"
    results << "<dd class=\"field\">#{field}</dd>"
    return results.html_safe
  end

  def display_audio_sample_rate
    field = String.new
    results = String.new
    if get_values_from_datastream(@document_fedora, "descMetadata", [:audio_sample_rate]).first.empty?
      field << "unavailable"
    else
      field << get_values_from_datastream(@document_fedora, "descMetadata", [:audio_sample_rate]).first
      unless get_values_from_datastream(@document_fedora, "descMetadata", [:audio_sample_rate_units]).first.empty?
        units = get_values_from_datastream(@document_fedora, "descMetadata", [:audio_sample_rate_units]).first
        field << " " + ["(", units, ")"].join
      end
    end
    results << "<dt><label for=\"audio_bit_rate\">Audio Sample Rate</label></dt>"
    results << "<dd class=\"field\">#{field}</dd>"
    return results.html_safe
  end




end