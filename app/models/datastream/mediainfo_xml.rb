require 'mediainfo'

class MediainfoXml < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(:path=>"Mediainfo")
    t.file(:path=>"File") {

      t.general(:path=>"track", :attributes=>{ :type=>"General"}) {
        t.audio_format_list(:path=>"Audio_Format_List")
        t.audio_format_withhint_list(:path=>"Audio_Format_WithHint_List")
        t.audio_language_list(:path=>"Audio_Language_List")
        t.audio_codecs(:path=>"Audio_codecs")
        t.codec(:path=>"Codec")
        t.codec_extensions_usually_used(:path=>"Codec_Extensions_usually_used")
        t.codec_id(:path=>"Codec_ID")
        t.codec_id_url(:path=>"Codec_ID_Url")
        t.codecs_video(:path=>"Codecs_Video")
        t.commercial_name(:path=>"Commercial_name")
        t.complete_name(:path=>"Complete_name")
        t.count(:path=>"Count")
        t.count_of_audio_streams(:path=>"Count_of_audio_streams")
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind")
        t.count_of_video_streams(:path=>"Count_of_video_streams")
        t.datasize(:path=>"DataSize")
        t.duration(:path=>"Duration")
        t.file_extension(:path=>"File_extension")
        t.file_last_modification_date(:path=>"File_last_modification_date")
        t.file_last_modification_date__local_(:path=>"File_last_modification_date__local_")
        t.file_name(:path=>"File_name")
        t.file_size(:path=>"File_size")
        t.footersize(:path=>"FooterSize")
        t.format(:path=>"Format")
        t.format_extensions_usually_used(:path=>"Format_Extensions_usually_used")
        t.format_profile(:path=>"Format_profile")
        t.headersize(:path=>"HeaderSize")
        t.internet_media_type(:path=>"Internet_media_type")
        t.isstreamable(:path=>"IsStreamable")
        t.kind_of_stream(:path=>"Kind_of_stream")
        t.overall_bit_rate(:path=>"Overall_bit_rate")
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream")
        t.stream_identifier(:path=>"Stream_identifier")
        t.stream_size(:path=>"Stream_size")
        t.video_format_list(:path=>"Video_Format_List")
        t.video_format_withhint_list(:path=>"Video_Format_WithHint_List")
        t.video_language_list(:path=>"Video_Language_List")
        t.writing_application(:path=>"Writing_application")
      }

      t.video(:path=>"track", :attributes=>{ :type=>"Video"}) {
        t.bit_depth(:path=>"Bit_depth")
        t.bit_rate(:path=>"Bit_rate")
        t.bit_rate_mode(:path=>"Bit_rate_mode")
        t.bits__pixel_frame_(:path=>"Bits__Pixel_Frame_")
        t.chroma_subsampling(:path=>"Chroma_subsampling")
        t.codec(:path=>"Codec")
        t.codec_cc(:path=>"Codec_CC")
        t.codec_family(:path=>"Codec_Family")
        t.codec_id(:path=>"Codec_ID")
        t.codec_id_info(:path=>"Codec_ID_Info")
        t.codec_id_url(:path=>"Codec_ID_Url")
        t.codec_info(:path=>"Codec_Info")
        t.codec_settings_refframes(:path=>"Codec_Settings_RefFrames")
        t.codec_url(:path=>"Codec_Url")
        t.codec_profile(:path=>"Codec_profile")
        t.codec_settings(:path=>"Codec_settings")
        t.codec_settings__cabac(:path=>"Codec_settings__CABAC")
        t.color_space(:path=>"Color_space")
        t.colorimetry(:path=>"Colorimetry")
        t.commercial_name(:path=>"Commercial_name")
        t.count(:path=>"Count")
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind")
        t.display_aspect_ratio(:path=>"Display_aspect_ratio")
        t.duration(:path=>"Duration")
        t.encoding_settings(:path=>"Encoding_settings")
        t.format(:path=>"Format")
        t.format_info(:path=>"Format_Info")
        t.format_url(:path=>"Format_Url")
        t.format_profile(:path=>"Format_profile")
        t.format_settings(:path=>"Format_settings")
        t.format_settings__cabac(:path=>"Format_settings__CABAC")
        t.format_settings__reframes(:path=>"Format_settings__ReFrames")
        t.framerate_mode_original(:path=>"FrameRate_Mode_Original")
        t.frame_count(:path=>"Frame_count")
        t.frame_rate(:path=>"Frame_rate")
        t.frame_rate_mode(:path=>"Frame_rate_mode")
        t.height(:path=>"Height")
        t.id_(:path=>"ID")
        t.interlacement(:path=>"Interlacement")
        t.internet_media_type(:path=>"Internet_media_type")
        t.kind_of_stream(:path=>"Kind_of_stream")
        t.language(:path=>"Language")
        t.pixel_aspect_ratio(:path=>"Pixel_aspect_ratio")
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream")
        t.resolution(:path=>"Resolution")
        t.rotation(:path=>"Rotation")
        t.scan_type(:path=>"Scan_type")
        t.stream_identifier(:path=>"Stream_identifier")
        t.stream_size(:path=>"Stream_size")
        t.width(:path=>"Width")
        t.writing_library(:path=>"Writing_library")
        t.writing_library_name(:path=>"Writing_library_Name")
        t.writing_library_version(:path=>"Writing_library_Version")
      }

      t.audio(:path=>"track", :attributes=>{ :type=>"Audio"}) {
        t.bit_rate(:path=>"Bit_rate")
        t.bit_rate_mode(:path=>"Bit_rate_mode")
        t.channel_positions(:path=>"Channel_positions")
        t.channel_s_(:path=>"Channel_s_")
        t.codec(:path=>"Codec")
        t.codec_cc(:path=>"Codec_CC")
        t.codec_family(:path=>"Codec_Family")
        t.codec_id(:path=>"Codec_ID")
        t.commercial_name(:path=>"Commercial_name")
        t.compression_mode(:path=>"Compression_mode")
        t.count(:path=>"Count")
        t.count_of_stream_of_this_kind(:path=>"Count_of_stream_of_this_kind")
        t.duration(:path=>"Duration")
        t.format(:path=>"Format")
        t.format_info(:path=>"Format_Info")
        t.format_profile(:path=>"Format_profile")
        t.id_(:path=>"ID")
        t.kind_of_stream(:path=>"Kind_of_stream")
        t.language(:path=>"Language")
        t.proportion_of_this_stream(:path=>"Proportion_of_this_stream")
        t.samples_count(:path=>"Samples_count")
        t.sampling_rate(:path=>"Sampling_rate")
        t.stream_identifier(:path=>"Stream_identifier")
        t.stream_size(:path=>"Stream_size")
      }

    }

    t.general_count(:ref=>[:file, :general, :count])
    t.chroma_subsampling(:ref=>[:file, :video, :chroma_subsampling])
    t.color_space(:ref=>[:file, :video, :color_space])
    t.height(:ref=>[:file, :video, :height])
    t.width(:ref=>[:file, :video, :width])
    t.file_size(:ref=>[:file, :general, :file_size])
    t.mi_file_format(:proxy=>[:file, :general, :format])
    t.duration(:proxy=>[:file, :video, :duration])


  end

  def color_space
    self.get_values([:file, :video, :color_space])
  end

  def chroma
    self.get_values([:file, :video, :chroma_subsampling])
  end

  def video_bit_depth
    result = self.get_values([:file, :video, :bit_depth])
    if result.empty?
      return nil
    else
      return result.first.match(/\d+/).to_s
    end
  end

  def video_bit_rate
    self.get_values([:file, :video, :bit_rate])
  end

  def audio_bit_rate
    self.get_values([:file, :audio, :bit_rate])
  end

  def audio_sample_rate
    self.get_values([:file, :audio, :sampling_rate])
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
    self.get_values([:file, :video, :duration]).each do |d|
      return d if d.match(/\d+:\d+:\d/)
    end
  end

  def size
    self.get_values([:file, :general, :file_size])
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