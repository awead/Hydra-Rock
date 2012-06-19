module TechDataHelper

  # This is an array of field names.  Some correspond to the delegated field in
  # ExternalVideo, others correspond to a formatted field that combines contents
  # from different fields into a specially formatted display field, such as file_size
  # which takes #size and #size_units
  def field_names
    r = Array.new
    r << "name"
    r << "location"
    r << "date"
    r << "generation"
    r << "media_type"
    r << "file_format"
    r << "size"
    r << "colors"
    r << "duration"
    r << "rights_summary"
    r << "note"
    r << "checksum_type"
    r << "checksum_value"
    r << "device"
    r << "capture_soft"
    r << "trans_soft"
    r << "operator"
    r << "trans_note"
    r << "vendor"
    r << "condition"
    r << "cleaning"
    r << "color_space"
    r << "chroma"
    r << "standard"
    r << "language"
    r << "video_standard"
    r << "video_encoding"
    r << "video_bit_rate"
    r << "frame_rate"
    r << "frame_size"
    r << "video_bit_depth"
    r << "aspect_ratio"
    r << "audio_standard"
    r << "audio_encoding"
    r << "audio_bit_rate"
    r << "audio_sample_rate"
    r << "audio_bit_depth"
    r << "audio_channels"
    r << "depositor"
    return r
  end

  # Cycles through every field in #field_names.  If there is no method defined in
  # this module with the same name, it will return the delegate mapping.  Otherwise,
  # it calls the method here and returns whatever the specially-formatted response is.
  def display_tech_data_field(field)
    if TechDataHelper.instance_methods.include?(field.to_sym)
      return send field.to_sym
    else
      if @afdoc.send(field.to_sym).empty? or @afdoc.send(field.to_sym).first.blank?
        return display_mediainfo_field(field)
      else
        return @afdoc.send(field.to_sym).first
      end
    end
  end

  def display_mediainfo_field(field)
    if @afdoc.datastreams["mediaInfo"].respond_to?(field.to_sym)
      value = @afdoc.datastreams["mediaInfo"].send(field.to_sym)
      value.is_a?(Array) ? value.first : value
    else
      return nil
    end
  end

  def format_with_units(field,unit)
    if @afdoc.send(field.to_sym).first.empty?
      return nil
    else
      if @afdoc.send(unit.to_sym).first.empty?
        return @afdoc.send(field.to_sym).first
      else
        return @afdoc.send(field.to_sym).first + " (" + @afdoc.send(unit.to_sym).first + ")"
      end
    end
  end

  def size
    if @afdoc.size.empty? or @afdoc.size.first == "0"
      return display_mediainfo_field(:size)
    else
      return format_with_units(:size,:size_units)
    end
  end

  def video_bit_rate
    result = format_with_units(:video_bit_rate,:video_bit_rate_units)
    result.nil? ? display_mediainfo_field(:video_bit_rate) : result
  end

  def audio_bit_rate
    result = format_with_units(:audio_bit_rate,:audio_bit_rate_units)
    result.nil? ? display_mediainfo_field(:audio_bit_rate) : result
  end

  def audio_sample_rate
    result = format_with_units(:audio_sample_rate,:audio_sample_rate_units)
    result.nil? ? display_mediainfo_field(:audio_sample_rate) : result
  end

end