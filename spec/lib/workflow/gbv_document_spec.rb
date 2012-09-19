require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::GbvDocument do

  before(:all) do
    file = File.new("spec/fixtures/rockhall/gbv_document_fixture.xml")
    xml = Nokogiri::XML(file)
    @doc = Workflow::GbvDocument.from_xml(xml)
  end


  it "should have all the required fields" do
    @doc.title_array.first.should                     == "Sun Records. 151.02 TRT-5:40."
    @doc.barcode_array.first.should                   == "39156042448451"
    @doc.orig_date_array.first.should                 == ""
    @doc.standard_array.first.should                  == "NTSC"
    @doc.condition_array.first.should                 == ""
    @doc.format_array.first.should                    == "Betacam"
    @doc.cleaning_array.first.should                  == ""
    @doc.p_name_array.first.should                    == "39156042439369_preservation"
    @doc.p_create_date_array.first.should             == "9/11/2012"
    @doc.p_file_format_array.first.should             == ".mov"
    @doc.p_size_array.first.should                    == "13434.97"
    @doc.p_size_units_array.first.should              == "MB"
    @doc.p_duration_array.first.should                == "0:07:56"
    @doc.p_video_codec_array.first.should             == "AJA v210"
    @doc.p_video_bit_rate_array.first.should          == "224"
    @doc.p_video_bit_rate_units_array.first.should    == "Mbps"
    @doc.p_video_bit_depth_array.first.should         == "10"
    @doc.p_frame_rate_array.first.should              == "29.97"
    @doc.p_frame_size_array.first.should              == "720 X 486"
    @doc.p_ratio_array.first.should                   == "4 X 3"
    @doc.p_chroma_array.first.should                  == "4:2:2"
    @doc.p_color_space_array.first.should             == "YUV"
    @doc.p_audio_encoding_array.first.should          == "in24"
    @doc.p_audio_standard_array.first.should          == "PCM"
    @doc.p_audio_bit_rate_array.first.should          == "1152"
    @doc.p_audio_bit_rate_unit_array.first.should     == "Kbps"
    @doc.p_audio_sample_rate_array.first.should       == "48"
    @doc.p_audio_sample_rate_unit_array.first.should  == "kHz"
    @doc.p_audio_bit_depth_array.first.should         == "24"
    @doc.p_audio_channels_array.first.should          == "2"
    @doc.p_checksum_type_array.first.should           == "md5"
    @doc.p_checksum_value_array.first.should          == "7349999933fc679f52e5c04afed039ce"
    @doc.device_array.first.should                    == "Sony BVW-75"
    @doc.capture_soft_array.first.should              == "Apple FCP 7 (ver 7.0.3)"
    @doc.p_trans_note_array.first.should              == ""
    @doc.p_operator_array.first.should                == "TM"
    @doc.p_vendor_array.first.should                  == "George Blood Audio and Video"
    @doc.a_name_array.first.should                    == "39156042448451_access"
    @doc.a_create_date_array.first.should             == "9/11/2012"
    @doc.a_file_format_array.first.should             == ".mp4"
    @doc.a_size_array.first.should                    == "163.83"
    @doc.a_size_units_array.first.should              == "MB"
    @doc.a_duration_array.first.should                == "0:07:56"
    @doc.a_video_codec_array.first.should             == "avc1"
    @doc.a_video_bit_rate_array.first.should          == "2507"
    @doc.a_video_bit_rate_units_array.first.should    == "Kbps"
    @doc.a_video_bit_depth_array.first.should         == "8"
    @doc.a_frame_rate_array.first.should              == "29.97"
    @doc.a_frame_size_array.first.should              == "640 X 480"
    @doc.a_ratio_array.first.should                   == "4:3"
    @doc.a_chroma_array.first.should                  == "4:2:0"
    @doc.a_color_space_array.first.should             == "YUV"
    @doc.a_audio_encoding_array.first.should          == "MPEG4"
    @doc.a_audio_standard_array.first.should          == "AAC"
    @doc.a_audio_bit_rate_array.first.should          == "256"
    @doc.a_audio_bit_rate_unit_array.first.should     == "Kbps"
    @doc.a_audio_sample_rate_array.first.should       == "48.0"
    @doc.a_audio_sample_rate_unit_array.first.should  == "kHz"
    @doc.a_audio_bit_depth_array.first.should         == "16"
    @doc.a_audio_channels_array.first.should          == "2"
    @doc.a_checksum_type_array.first.should           == "md5"
    @doc.a_checksum_value_array.first.should          == "a5aee22426815523413231d23fc38e5c"
    @doc.trans_soft_array.first.should                == "MPEG Streamclip 1.92"
    @doc.a_trans_note_array.first.should              == ""
    @doc.a_operator_array.first.should                == "TM"
    @doc.a_vendor_array.first.should                  == "George Blood Audio and Video"
  end


end