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
    r << "file_size"
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
      return @afdoc.send(field.to_sym).first
    end
  end

  def format_with_units(field,unit)
    if @afdoc.send(field.to_sym).first.empty?
      return "unavailable"
    else
      if @afdoc.send(unit.to_sym).first.empty?
        return @afdoc.send(field.to_sym).first
      else
        return @afdoc.send(field.to_sym).first + " (" + @afdoc.send(unit.to_sym).first + ")"
      end
    end
  end

  def file_size
    return format_with_units(:size,:size_units)
  end

  def video_bit_rate
    return format_with_units(:video_bit_rate,:video_bit_rate_units)
  end

  def audio_bit_rate
    return format_with_units(:audio_bit_rate,:audio_bit_rate_units)
  end

  def audio_sample_rate
    return format_with_units(:audio_sample_rate,:audio_sample_rate_units)
  end

end