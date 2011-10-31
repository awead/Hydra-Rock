require 'mediainfo'

module MediainfoXml
class Document < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"Mediainfo", :namespace_prefix=>nil)
    t.file(:path=>"File", :namespace_prefix=>nil) {

      t.general(:path=>"track", :attributes=>{ :type=>"General"}, :namespace_prefix=>nil) {
        t.audio_format_list(:path=>"Audio_Format_List", :namespace_prefix=>nil)
        t.audio_format_withhint_list(:path=>"Audio_Format_WithHint_List", :namespace_prefix=>nil)
        t.audio_language_list(:path=>"Audio_Language_List", :namespace_prefix=>nil)
        t.audio_codecs(:path=>"Audio_codecs", :namespace_prefix=>nil)
        t.codec(:path=>"Codec", :namespace_prefix=>nil)
        t.codec_extensions_usually_used(:path=>"Codec_Extensions_usually_used", :namespace_prefix=>nil)
        t.codec_id(:path=>"Codec_ID", :namespace_prefix=>nil)
        t.codec_id_url(:path=>"Codec_ID_Url", :namespace_prefix=>nil)
        t.codecs_video(:path=>"Codecs_Video", :namespace_prefix=>nil)
        t.commercial_name(:path=>"Commercial_name", :namespace_prefix=>nil)
        t.complete_name(:path=>"Complete_name", :namespace_prefix=>nil)
        t.count(:path=>"Count", :namespace_prefix=>nil)
        t.count_of_audio_streams(:path=>"Count_of_audio_streams", :namespace_prefix=>nil)
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind", :namespace_prefix=>nil)
        t.count_of_video_streams(:path=>"Count_of_video_streams", :namespace_prefix=>nil)
        t.datasize(:path=>"DataSize", :namespace_prefix=>nil)
        t.duration(:path=>"Duration", :namespace_prefix=>nil)
        t.file_extension(:path=>"File_extension", :namespace_prefix=>nil)
        t.file_last_modification_date(:path=>"File_last_modification_date", :namespace_prefix=>nil)
        t.file_last_modification_date__local_(:path=>"File_last_modification_date__local_", :namespace_prefix=>nil)
        t.file_name(:path=>"File_name", :namespace_prefix=>nil)
        t.file_size(:path=>"File_size", :namespace_prefix=>nil)
        t.footersize(:path=>"FooterSize", :namespace_prefix=>nil)
        t.format(:path=>"Format", :namespace_prefix=>nil)
        t.format_extensions_usually_used(:path=>"Format_Extensions_usually_used", :namespace_prefix=>nil)
        t.format_profile(:path=>"Format_profile", :namespace_prefix=>nil)
        t.headersize(:path=>"HeaderSize", :namespace_prefix=>nil)
        t.internet_media_type(:path=>"Internet_media_type", :namespace_prefix=>nil)
        t.isstreamable(:path=>"IsStreamable", :namespace_prefix=>nil)
        t.kind_of_stream(:path=>"Kind_of_stream", :namespace_prefix=>nil)
        t.overall_bit_rate(:path=>"Overall_bit_rate", :namespace_prefix=>nil)
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream", :namespace_prefix=>nil)
        t.stream_identifier(:path=>"Stream_identifier", :namespace_prefix=>nil)
        t.stream_size(:path=>"Stream_size", :namespace_prefix=>nil)
        t.video_format_list(:path=>"Video_Format_List", :namespace_prefix=>nil)
        t.video_format_withhint_list(:path=>"Video_Format_WithHint_List", :namespace_prefix=>nil)
        t.video_language_list(:path=>"Video_Language_List", :namespace_prefix=>nil)
        t.writing_application(:path=>"Writing_application", :namespace_prefix=>nil)
      }

      t.video(:path=>"track", :attributes=>{ :type=>"Video"}, :namespace_prefix=>nil) {
        t.bit_depth(:path=>"Bit_depth", :namespace_prefix=>nil)
        t.bit_rate(:path=>"Bit_rate", :namespace_prefix=>nil)
        t.bit_rate_mode(:path=>"Bit_rate_mode", :namespace_prefix=>nil)
        t.bits__pixel_frame_(:path=>"Bits__Pixel_Frame_", :namespace_prefix=>nil)
        t.chroma_subsampling(:path=>"Chroma_subsampling", :namespace_prefix=>nil)
        t.codec(:path=>"Codec", :namespace_prefix=>nil)
        t.codec_cc(:path=>"Codec_CC", :namespace_prefix=>nil)
        t.codec_family(:path=>"Codec_Family", :namespace_prefix=>nil)
        t.codec_id(:path=>"Codec_ID", :namespace_prefix=>nil)
        t.codec_id_info(:path=>"Codec_ID_Info", :namespace_prefix=>nil)
        t.codec_id_url(:path=>"Codec_ID_Url", :namespace_prefix=>nil)
        t.codec_info(:path=>"Codec_Info", :namespace_prefix=>nil)
        t.codec_settings_refframes(:path=>"Codec_Settings_RefFrames", :namespace_prefix=>nil)
        t.codec_url(:path=>"Codec_Url", :namespace_prefix=>nil)
        t.codec_profile(:path=>"Codec_profile", :namespace_prefix=>nil)
        t.codec_settings(:path=>"Codec_settings", :namespace_prefix=>nil)
        t.codec_settings__cabac(:path=>"Codec_settings__CABAC", :namespace_prefix=>nil)
        t.color_space(:path=>"Color_space", :namespace_prefix=>nil)
        t.colorimetry(:path=>"Colorimetry", :namespace_prefix=>nil)
        t.commercial_name(:path=>"Commercial_name", :namespace_prefix=>nil)
        t.count(:path=>"Count", :namespace_prefix=>nil)
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind", :namespace_prefix=>nil)
        t.display_aspect_ratio(:path=>"Display_aspect_ratio", :namespace_prefix=>nil)
        t.duration(:path=>"Duration", :namespace_prefix=>nil)
        t.encoding_settings(:path=>"Encoding_settings", :namespace_prefix=>nil)
        t.format(:path=>"Format", :namespace_prefix=>nil)
        t.format_info(:path=>"Format_Info", :namespace_prefix=>nil)
        t.format_url(:path=>"Format_Url", :namespace_prefix=>nil)
        t.format_profile(:path=>"Format_profile", :namespace_prefix=>nil)
        t.format_settings(:path=>"Format_settings", :namespace_prefix=>nil)
        t.format_settings__cabac(:path=>"Format_settings__CABAC", :namespace_prefix=>nil)
        t.format_settings__reframes(:path=>"Format_settings__ReFrames", :namespace_prefix=>nil)
        t.framerate_mode_original(:path=>"FrameRate_Mode_Original", :namespace_prefix=>nil)
        t.frame_count(:path=>"Frame_count", :namespace_prefix=>nil)
        t.frame_rate(:path=>"Frame_rate", :namespace_prefix=>nil)
        t.frame_rate_mode(:path=>"Frame_rate_mode", :namespace_prefix=>nil)
        t.height(:path=>"Height", :namespace_prefix=>nil)
        t.id_(:path=>"ID", :namespace_prefix=>nil)
        t.interlacement(:path=>"Interlacement", :namespace_prefix=>nil)
        t.internet_media_type(:path=>"Internet_media_type", :namespace_prefix=>nil)
        t.kind_of_stream(:path=>"Kind_of_stream", :namespace_prefix=>nil)
        t.language(:path=>"Language", :namespace_prefix=>nil)
        t.pixel_aspect_ratio(:path=>"Pixel_aspect_ratio", :namespace_prefix=>nil)
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream", :namespace_prefix=>nil)
        t.resolution(:path=>"Resolution", :namespace_prefix=>nil)
        t.rotation(:path=>"Rotation", :namespace_prefix=>nil)
        t.scan_type(:path=>"Scan_type", :namespace_prefix=>nil)
        t.stream_identifier(:path=>"Stream_identifier", :namespace_prefix=>nil)
        t.stream_size(:path=>"Stream_size", :namespace_prefix=>nil)
        t.width(:path=>"Width", :namespace_prefix=>nil)
        t.writing_library(:path=>"Writing_library", :namespace_prefix=>nil)
        t.writing_library_name(:path=>"Writing_library_Name", :namespace_prefix=>nil)
        t.writing_library_version(:path=>"Writing_library_Version", :namespace_prefix=>nil)
      }

      t.audio(:path=>"track", :attributes=>{ :type=>"Audio"}, :namespace_prefix=>nil) {
        t.bit_rate(:path=>"Bit_rate", :namespace_prefix=>nil)
        t.bit_rate_mode(:path=>"Bit_rate_mode", :namespace_prefix=>nil)
        t.channel_positions(:path=>"Channel_positions", :namespace_prefix=>nil)
        t.channel_s_(:path=>"Channel_s_", :namespace_prefix=>nil)
        t.codec(:path=>"Codec", :namespace_prefix=>nil)
        t.codec_cc(:path=>"Codec_CC", :namespace_prefix=>nil)
        t.codec_family(:path=>"Codec_Family", :namespace_prefix=>nil)
        t.codec_id(:path=>"Codec_ID", :namespace_prefix=>nil)
        t.commercial_name(:path=>"Commercial_name", :namespace_prefix=>nil)
        t.compression_mode(:path=>"Compression_mode", :namespace_prefix=>nil)
        t.count(:path=>"Count", :namespace_prefix=>nil)
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind", :namespace_prefix=>nil)
        t.duration(:path=>"Duration", :namespace_prefix=>nil)
        t.format(:path=>"Format", :namespace_prefix=>nil)
        t.format_info(:path=>"Format_Info", :namespace_prefix=>nil)
        t.format_profile(:path=>"Format_profile", :namespace_prefix=>nil)
        t.id_(:path=>"ID", :namespace_prefix=>nil)
        t.kind_of_stream(:path=>"Kind_of_stream", :namespace_prefix=>nil)
        t.language(:path=>"Language", :namespace_prefix=>nil)
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream", :namespace_prefix=>nil)
        t.samples_count(:path=>"Samples_count", :namespace_prefix=>nil)
        t.sampling_rate(:path=>"Sampling_rate", :namespace_prefix=>nil)
        t.stream_identifier(:path=>"Stream_identifier", :namespace_prefix=>nil)
        t.stream_size(:path=>"Stream_size", :namespace_prefix=>nil)
      }

    }

    t.general_count(:ref=>[:file, :general, :count], :namespace_prefix=>nil)
    t.chroma_subsampling(:ref=>[:file, :video, :chroma_subsampling], :namespace_prefix=>nil)
    t.color_space(:ref=>[:file, :video, :color_space], :namespace_prefix=>nil)
    t.height(:ref=>[:file, :video, :height], :namespace_prefix=>nil)
    t.width(:ref=>[:file, :video, :width], :namespace_prefix=>nil)


  end

  def bit_depth
    result = String.new
    result << self.get_values([:file, :video, :bit_depth]).first.match(/\d+/).to_s
    if result.nil?
      return nil
    else
      return result
    end
  end

  def aspect_ratio
    result = String.new
    self.get_values([:file, :video, :display_aspect_ratio]).each do |r|
      unless r.match(/:/).nil?
        result = r
      end
    end
    if result.nil?
      return nil
    else
      return result
    end
  end

  def frame_size
    result = String.new
    result << self.width.first.match(/\d+/).to_s
    result << "x"
    result << self.height.first.match(/\d+/).to_s

    if result.match(/^\d+x\d+$/).nil?
      return nil
    else
      return result
    end

  end

  def duration
    results = String.new
    self.get_values([:file, :video, :duration]).each do |v|
      unless v.match(/^\d+:\d+:\d+\.\d+$/).nil?
        return v
      end
    end
    return nil
  end

  def self.from_file(file)
    f = File.new(file)
    info = Mediainfo.new f
    xml = info.raw_response
    if xml.empty?
      raise "Mediainfo xml is empty"
    end
    return self.from_xml(xml)
  end

end
end