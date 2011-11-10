module Workflow
class GbvDocument < ActiveFedora::NokogiriDatastream

  include Rockhall::WorkflowMethods

  set_terminology do |t|
    t.root(:path=>"FMPXMLRESULT", :xmlns=>"http://www.filemaker.com/fmpxmlresult")

    t.resultset(:path=>"RESULTSET") {
      t.row(:path=>"ROW") {
        t.col(:path=>"COL")
      }
    }

    t.data(:ref=>[:resultset, :row, :col])

  end

  def respond(value)
    unless value.empty?
      return value
    end
  end

  # Fields from xml file, listed by column id

  # A Original: Barcode
  def barcode
    unless self.data[0].match(/^3[0-9]+$/).nil?
      return self.data[0]
    end
  end

  # B - Original: Label Title (transcribed from label/container)
  def title
    return respond(self.data[1])
  end

  # C - Original: Recording Date (yyyy-mm-dd)
  def orig_date
    return parse_date(self.data[2])
  end

  # D - Original: Video Standard
  def standard
    return respond(self.data[3])
  end

  # E - Original: Condition Notes
  def condition
    return respond(self.data[4])
  end

  # F - Original: Cleaning Notes
  def format
    return respond(self.data[5])
  end

  # G - Original: Cleaning Notes
  def cleaning
    return respond(self.data[6])
  end

  # H - Pres Master: File Name
  def p_name
    return respond(self.data[7])
  end

  # I - Pres Master: Date Created (mm-dd-yyyy)
  def p_create_date
    return parse_date(self.data[8])
  end

  # J - Pres Master: File Format (extension)
  def p_file_format
    return respond(self.data[9]).gsub(/\./,"")
  end

  # K - Pres master: file size value
  def p_size
    return respond(self.data[10])
  end

  # L - Pres Master: File Size Unit of Measure (MB)
  def p_size_units
    return respond(self.data[11])
  end

  # M - Pres Master: Duration (HH:MM:SS)
  def p_duration
    return respond(self.data[12])
  end

  # N - Pres Master: Video Codec
  def p_video_codec
    return parse_codec(self.data[13])
  end

  # O - Pres Master: Video Bit Rate Value
  def p_video_bit_rate
    return respond(self.data[14])
  end

  # P - Pres Master: Video Bit Rate Unit of Measure (kbps)
  def p_video_bit_rate_units
    return respond(self.data[15])
  end

  # Q - Pres Master: Video Bit Depth
  def p_video_bit_depth
    return respond(self.data[16])
  end

  # R - Pres Master: Video Frame Rate
  def p_frame_rate
    return respond(self.data[17])
  end

  # S - Pres Master: Video Frame Size (pixels: W x H)
  def p_frame_size
    return parse_size(self.data[18])
  end

  # T - Pres Master: Video Aspect Ratio (W:H)
  def p_ratio
    return parse_ratio(self.data[19])
  end

  # U - Pres Master: Video Chroma Subsampling
  def p_chroma
    return respond(self.data[20])
  end

  # V - Pres Master: Video Color Space
  def p_color_space
    return respond(self.data[21])
  end

  # W - Pres Master: Audio Codec
  # Note: this is slightly misleading. On the video side, this field is used for the NTSC standard.
  # and here is technically isn't a standard but is another name for code, ie. in24 or MPEG4.
  def p_audio_standard
    return respond(self.data[22])
  end

  # X  - Pres Master: Audio Data Encoding
  def p_audio_encoding
    return parse_codec(self.data[23])
  end

  # Y  - Pres Master: Audio Bit Rate Value
  def p_audio_bit_rate
    return respond(self.data[24])
  end

  # Z  - Pres Master: Audio Bit Rate Unit of Measure (kbps)
  def p_audio_bit_rate_unit
    return respond(self.data[25])
  end

  # AA - Pres Master: Audio Sampling Rate
  def p_audio_sample_rate
    return respond(self.data[26])
  end

  # AB - Pres Master: Audio Sampling Rate Unit
  def p_audio_sample_rate_unit
    return respond(self.data[27])
  end

  # AC - Pres Master: Audio Bit Depth
  def p_audio_bit_depth
    return respond(self.data[28])
  end

  # AD - Pres Master: Audio Channels (number of)
  def p_audio_channels
    return respond(self.data[29])
  end

  # AE - Pres Master: Checksum Type
  def p_checksum_type
    return respond(self.data[30])
  end

  # AF - Pres Master: Checksum Value
  def p_checksum_value
    return respond(self.data[31])
  end

  # AG - Pres Master: Playback Device (Make, model)
  def device
    return respond(self.data[32])
  end

  # AH - Pres Master: Capture Software (Name, version)
  def capture_soft
    return respond(self.data[33])
  end

  # AI - Pres Master: Transfer Notes
  def p_trans_note
    return respond(self.data[34])
  end

  # AJ
  def p_operator
    return respond(self.data[35])
  end

  # AK - Pres Master: Vendor Name
  def p_vendor
    return respond(self.data[36])
  end

  # AL - Access Copy: File Name
  def a_name
    return respond(self.data[37])
  end

  # AM - Access Copy: Date Created (mm-dd-yyyy)
  def a_create_date
    return parse_date(self.data[38])
  end

  # AN - Access Copy:  File Format (extension)
  def a_file_format
    return respond(self.data[39]).gsub(/\./,"")
  end

  # AO - Access Copy: File Size Value
  def a_size
    return respond(self.data[40])
  end

  # AP - Access Copy: File Size Unit of Measure (MB)
  def a_size_units
    return respond(self.data[41])
  end

  # AQ - Access Copy: Duration (HH:MM:SS)
  def a_duration
    return respond(self.data[42])
  end

  # AR - Access Copy: Video Codec
  def a_video_codec
    return parse_codec(self.data[43])
  end

  # AS - Access Copy: Video Bit Rate Value
  def a_video_bit_rate
    return respond(self.data[44])
  end

  # AT - Access Copy: Video Bit Rate Unit of Measure (kbps)
  def a_video_bit_rate_units
    return respond(self.data[45])
  end

  # AU - Access Copy: Video Bit Depth
  def a_video_bit_depth
    return respond(self.data[46])
  end

  # AV - Access Copy: Video Frame Rate
  def a_frame_rate
    return respond(self.data[47])
  end

  # AW - Access Copy: Video Frame Size (pixels: W x H)
  def a_frame_size
    return parse_size(self.data[48])
  end

  # AX - Access Copy: Video Aspect Ratio (W:H)
  def a_ratio
    return parse_ratio(self.data[49])
  end

  # AY - Access Copy: Video Chroma Subsampling
  def a_chroma
    return respond(self.data[50])
  end

  # AZ - Access Copy: Video Color Space
  def a_color_space
    return respond(self.data[51])
  end

  # BA - Access Copy: Audio Codec
  # See note for field W
  def a_audio_standard
    return respond(self.data[52])
  end

  # BB - Access Copy: Audio Data Encoding
  def a_audio_encoding
    return parse_codec(self.data[53])
  end

  # BC - Access Copy: Audio Bit Rate Value
  def a_audio_bit_rate
    return respond(self.data[54])
  end

  # BD - Access Copy: Audio Bit Rate Unit of Measure (kbps)
  def a_audio_bit_rate_unit
    return respond(self.data[55])
  end

  # BE - Access Copy: Audio Sampling Rate Value
  def a_audio_sample_rate
    return respond(self.data[56])
  end

  # BF - Access Copy: Audio Sampling Rate Unit(kHz)
  def a_audio_sample_rate_unit
    return respond(self.data[57])
  end

  # BG - Access Copy: Audio Bit Depth
  def a_audio_bit_depth
    return respond(self.data[58])
  end

  # BH - Access Copy: Audio Channels (number of)
  def a_audio_channels
    return respond(self.data[59])
  end

  # BI - Access Copy: Checksum Type
  def a_checksum_type
    return respond(self.data[60])
  end

  # BJ - Access Copy: Checksum Value
  def a_checksum_value
    return respond(self.data[61])
  end

  # BK - Access Copy: Transcoding Software (Name, version)
  def trans_soft
    return respond(self.data[62])
  end

  # BL - Access Copy: Transfer Notes
  def a_trans_note
    return respond(self.data[63])
  end

  # BM - Access Copy: Engineer Name
  def a_operator
    return respond(self.data[64])
  end

  # BN - Access Copy: Vendor Name
  def a_vendor
    return respond(self.data[65])
  end

end
end