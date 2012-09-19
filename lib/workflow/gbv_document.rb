module Workflow
class GbvDocument < ActiveFedora::NokogiriDatastream

  include Rockhall::WorkflowMethods

  set_terminology do |t|
    t.root(:path=>"/VideoObject", :xmlns=> nil)

    t.barcode_array(:path => "/VideoObject/Original/Barcode")
    t.title_array(:path => "/VideoObject/Original/LabelTitle")
    t.orig_date_array(:path => "/VideoObject/Original/RecordDate")
    t.standard_array(:path => "/VideoObject/Original/VideoStandard")
    t.condition_array(:path => "/VideoObject/Original/ConditionNotes")
    t.format_array(:path => "/VideoObject/Original/FormatType")
    t.cleaning_array(:path => "/VideoObject/Original/CleaningNotes")
    t.p_name_array(:path => "/VideoObject/PreservationMaster/FileName")
    t.p_create_date_array(:path => "/VideoObject/PreservationMaster/DateCreated")
    t.p_file_format_array(:path => "/VideoObject/PreservationMaster/FileFormatWrapper")
    t.p_size_array(:path => "/VideoObject/PreservationMaster/FileSize")
    t.p_size_units_array(:path => "/VideoObject/PreservationMaster/FileSizeUnit")
    t.p_duration_array(:path => "/VideoObject/Original/Duration")
    t.p_video_codec_array(:path => "/VideoObject/PreservationMaster/VideoCodec")
    t.p_video_bit_rate_array(:path => "/VideoObject/PreservationMaster/VideoBitRate")
    t.p_video_bit_rate_units_array(:path => "/VideoObject/PreservationMaster/VideoBitRateUnit")
    t.p_video_bit_depth_array(:path => "/VideoObject/PreservationMaster/VideoBitDepth")
    t.p_frame_rate_array(:path => "/VideoObject/PreservationMaster/FrameRate")
    t.p_frame_size_array(:path => "/VideoObject/PreservationMaster/FrameSize")
    t.p_ratio_array(:path => "/VideoObject/PreservationMaster/AspectRatio")
    t.p_chroma_array(:path => "/VideoObject/PreservationMaster/ChromaSubSampling")
    t.p_color_space_array(:path => "/VideoObject/PreservationMaster/ColorSpace")
    t.p_audio_encoding_array(:path => "/VideoObject/PreservationMaster/AudioCodec")
    t.p_audio_standard_array(:path => "/VideoObject/PreservationMaster/AudioDataEncoding")
    t.p_audio_bit_rate_array(:path => "/VideoObject/PreservationMaster/AudioBitRate")
    t.p_audio_bit_rate_unit_array(:path => "/VideoObject/PreservationMaster/AudioBitRateUnit")
    t.p_audio_sample_rate_array(:path => "/VideoObject/PreservationMaster/AudioSamplingRate")
    t.p_audio_sample_rate_unit_array(:path => "/VideoObject/PreservationMaster/AudioSamplingRateUnit")
    t.p_audio_bit_depth_array(:path => "/VideoObject/PreservationMaster/AudioBitDepth")
    t.p_audio_channels_array(:path => "/VideoObject/PreservationMaster/AudioChannels")
    t.p_checksum_type_array(:path => "/VideoObject/PreservationMaster/CheckSumType")
    t.p_checksum_value_array(:path => "/VideoObject/PreservationMaster/CheckSumValue")
    t.device_array(:path => "/VideoObject/PreservationMaster/PlayBackDevice")
    t.capture_soft_array(:path => "/VideoObject/PreservationMaster/CaptureSoftware")
    t.p_trans_note_array(:path => "/VideoObject/PreservationMaster/TransferNotes")
    t.p_operator_array(:path => "/VideoObject/PreservationMaster/EngineerName")
    t.p_vendor_array(:path => "/VideoObject/PreservationMaster/VendorName")
    t.a_name_array(:path => "/VideoObject/AccessCopy/FileName")
    t.a_create_date_array(:path => "/VideoObject/AccessCopy/DateCreated")
    t.a_file_format_array(:path => "/VideoObject/AccessCopy/FileFormatWrapper")
    t.a_size_array(:path => "/VideoObject/AccessCopy/FileSize")
    t.a_size_units_array(:path => "/VideoObject/AccessCopy/FileSizeUnit")
    t.a_duration_array(:path => "/VideoObject/AccessCopy/Duration")
    t.a_video_codec_array(:path => "/VideoObject/AccessCopy/VideoCodec")
    t.a_video_bit_rate_array(:path => "/VideoObject/AccessCopy/VideoBitRate")
    t.a_video_bit_rate_units_array(:path => "/VideoObject/AccessCopy/VideoBitRateUnit")
    t.a_video_bit_depth_array(:path => "/VideoObject/AccessCopy/VideoBitDepth")
    t.a_frame_rate_array(:path => "/VideoObject/AccessCopy/FrameRate")
    t.a_frame_size_array(:path => "/VideoObject/AccessCopy/FrameSize")
    t.a_ratio_array(:path => "/VideoObject/AccessCopy/AspectRatio")
    t.a_chroma_array(:path => "/VideoObject/AccessCopy/ChromaSubSampling")
    t.a_color_space_array(:path => "/VideoObject/AccessCopy/ColorSpace")
    t.a_audio_encoding_array(:path => "/VideoObject/AccessCopy/AudioCodec")
    t.a_audio_standard_array(:path => "/VideoObject/AccessCopy/AudioDataEncoding")
    t.a_audio_bit_rate_array(:path => "/VideoObject/AccessCopy/AudioBitRate")
    t.a_audio_bit_rate_unit_array(:path => "/VideoObject/AccessCopy/AudioBitRateUnit")
    t.a_audio_sample_rate_array(:path => "/VideoObject/AccessCopy/AudioSamplingRate")
    t.a_audio_sample_rate_unit_array(:path => "/VideoObject/AccessCopy/AudioSamplingRateUnit")
    t.a_audio_bit_depth_array(:path => "/VideoObject/AccessCopy/AudioBitDepth")
    t.a_audio_channels_array(:path => "/VideoObject/AccessCopy/AudioChannels")
    t.a_checksum_type_array(:path => "/VideoObject/AccessCopy/CheckSumType")
    t.a_checksum_value_array(:path => "/VideoObject/AccessCopy/CheckSumValue")
    t.trans_soft_array(:path => "/VideoObject/AccessCopy/TranscodingSoftware")
    t.a_trans_note_array(:path => "/VideoObject/AccessCopy/TransferNotes")
    t.a_operator_array(:path => "/VideoObject/AccessCopy/EngineerName")
    t.a_vendor_array(:path => "/VideoObject/AccessCopy/VendorName")
  end

  def barcode
    return parse_empty(self.barcode_array.first)
  end

  def title
    return parse_empty(self.title_array.first)
  end

  def orig_date
    return parse_date(self.orig_date_array.first)
  end

  def standard
    return parse_empty(self.standard_array.first)
  end

  def condition
    return parse_empty(self.condition_array.first)
  end

  def format
    return parse_empty(self.format_array.first)
  end

  def cleaning
    return parse_empty(self.cleaning_array.first)
  end

  def p_name
  	return parse_empty(self.p_name_array.first)
  end

  def p_create_date
  	return parse_date(self.p_create_date_array.first)
  end

  def p_file_format
  	return parse_empty(self.p_file_format_array.first.gsub(/\./,""))
  end

  def p_size
  	return parse_empty(self.p_size_array.first)
  end

  def p_size_units
  	return parse_empty(self.p_size_units_array.first)
  end

  def p_duration
  	return parse_empty(self.p_duration_array.first)
  end

  def p_video_codec
  	return parse_empty(self.p_video_codec_array.first)
  end

  def p_video_bit_rate
  	return parse_empty(self.p_video_bit_rate_array.first)
  end

  def p_video_bit_rate_units
  	return parse_empty(self.p_video_bit_rate_units_array.first)
  end

  def p_video_bit_depth
  	return parse_empty(self.p_video_bit_depth_array.first)
  end

  def p_frame_rate
  	return parse_empty(self.p_frame_rate_array.first)
  end

  def p_frame_size
  	return parse_size(self.p_frame_size_array.first)
  end

  def p_ratio
  	return parse_ratio(self.p_ratio_array.first)
  end

  def p_chroma
  	return parse_empty(self.p_chroma_array.first)
  end

  def p_color_space
  	return parse_empty(self.p_color_space_array.first)
  end

  def p_audio_encoding
  	return parse_empty(self.p_audio_encoding_array.first)
  end

  def p_audio_standard
  	return parse_standard(self.p_audio_standard_array.first)
  end

  def p_audio_bit_rate
  	return parse_empty(self.p_audio_bit_rate_array.first)
  end

  def p_audio_bit_rate_unit
  	return parse_empty(self.p_audio_bit_rate_unit_array.first)
  end

  def p_audio_sample_rate
  	return parse_empty(self.p_audio_sample_rate_array.first)
  end

  def p_audio_sample_rate_unit
  	return parse_empty(self.p_audio_sample_rate_unit_array.first)
  end

  def p_audio_bit_depth
  	return parse_empty(self.p_audio_bit_depth_array.first)
  end

  def p_audio_channels
  	return parse_empty(self.p_audio_channels_array.first)
  end

  def p_checksum_type
  	return parse_empty(self.p_checksum_type_array.first)
  end

  def p_checksum_value
  	return parse_empty(self.p_checksum_value_array.first)
  end

  def device
  	return parse_empty(self.device_array.first)
  end

  def capture_soft
  	return parse_empty(self.capture_soft_array.first)
  end

  def p_trans_note
  	return parse_empty(self.p_trans_note_array.first)
  end

  def p_operator
  	return parse_empty(self.p_operator_array.first)
  end

  def p_vendor
  	return parse_empty(self.p_vendor_array.first)
  end

  def a_name
  	return parse_empty(self.a_name_array.first)
  end

  def a_create_date
  	return parse_date(self.a_create_date_array.first)
  end

  def a_file_format
  	return parse_empty(self.a_file_format_array.first.gsub(/\./,""))
  end

  def a_size
  	return parse_empty(self.a_size_array.first)
  end

  def a_size_units
  	return parse_empty(self.a_size_units_array.first)
  end

  def a_duration
  	return parse_empty(self.a_duration_array.first)
  end

  def a_video_codec
  	return parse_encoding(self.a_video_codec_array.first)
  end

  def a_video_bit_rate
  	return parse_empty(self.a_video_bit_rate_array.first)
  end

  def a_video_bit_rate_units
  	return parse_empty(self.a_video_bit_rate_units_array.first)
  end

  def a_video_bit_depth
  	return parse_empty(self.a_video_bit_depth_array.first)
  end

  def a_frame_rate
  	return parse_empty(self.a_frame_rate_array.first)
  end

  def a_frame_size
  	return parse_size(self.a_frame_size_array.first)
  end

  def a_ratio
  	return parse_ratio(self.a_ratio_array.first)
  end

  def a_chroma
  	return parse_empty(self.a_chroma_array.first)
  end

  def a_color_space
  	return parse_empty(self.a_color_space_array.first)
  end

  def a_audio_encoding
  	return parse_encoding(self.a_audio_encoding_array.first)
  end

  def a_audio_standard
  	return parse_standard(self.a_audio_standard_array.first)
  end

  def a_audio_bit_rate
  	return parse_empty(self.a_audio_bit_rate_array.first)
  end

  def a_audio_bit_rate_unit
  	return parse_empty(self.a_audio_bit_rate_unit_array.first)
  end

  def a_audio_sample_rate
  	return parse_empty(self.a_audio_sample_rate_array.first)
  end

  def a_audio_sample_rate_unit
  	return parse_empty(self.a_audio_sample_rate_unit_array.first)
  end

  def a_audio_bit_depth
  	return parse_empty(self.a_audio_bit_depth_array.first)
  end

  def a_audio_channels
  	return parse_empty(self.a_audio_channels_array.first)
  end

  def a_checksum_type
  	return parse_empty(self.a_checksum_type_array.first)
  end

  def a_checksum_value
  	return parse_empty(self.a_checksum_value_array.first)
  end

  def trans_soft
  	return parse_empty(self.trans_soft_array.first)
  end

  def a_trans_note
  	return parse_empty(self.a_trans_note_array.first)
  end

  def a_operator
  	return parse_empty(self.a_operator_array.first)
  end

  def a_vendor
  	return parse_empty(self.a_vendor_array.first)
  end



end
end