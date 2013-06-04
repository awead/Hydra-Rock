require "spec_helper"

describe Workflow::GbvIngest do

  before(:all) do
    Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
  end

  after(:all) do
    Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
  end

  before(:each) do
    @sip = Workflow::GbvSip.new(sip("39156042439369"))
  end

  describe "the entire ingestion process" do

    it "should prepare a sip and ingest it into Fedora" do
      FileUtils.cp_r(@sip.root,RH_CONFIG["location"])
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], @sip.base))
      copy.prepare
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.external_videos.length.should == 1
      ing.process
      ing.parent.external_videos.length.should == 3

      # Check parent object fields
      ing.parent.label.should == "George Blood Audio and Video"

      # Check the external video object representing the tape
      tape = ing.parent.external_videos.first
      tape.date.should      == ["2007-07-09"]
      tape.standard.should  == ["NTSC"]
      tape.format.should    == ["Betacam"]

      # Preservation file
      original = ExternalVideo.find(ing.parent.videos[:preservation].first.pid)

      # Preservation: Instantiation fields
      original.date.first.should                    == "2011-10-12"
      original.vendor.first.should                  == "George Blood Audio and Video"
      original.cleaning.first.should                be_nil
      original.condition.first.should               == "Bars and tone at end of program"
      original.file_format.first.should             == "mov"
      original.capture_soft.first.should            == "Apple FCP 7 (ver 7.0.3)"
      original.operator.first.should                == "TMu"
      original.trans_note.first.should              be_nil
      original.device.first.should                  == "Sony PVW-2800; 20040"
      original.chroma.first.should                  == "4:2:2"
      original.color_space.first.should             == "YUV"
      original.duration.first.should                == "0:50:47"
      original.colors.first.should                  == "Color"
      original.generation.first.should              == "Copy: preservation"
      original.media_type.first.should              == "Moving image"

      # Preservation: Video essence track fields
      original.video_standard.first.should          == "NTSC"
      original.video_encoding.first.should          == "AJA v210"
      original.video_bit_rate.first.should          == "224"
      original.video_bit_rate_units.first.should    == "Mbps"
      original.video_bit_depth.first.should         == "10"
      original.frame_rate.first.should              == "29.97"
      original.frame_size.first.should              == "720x486"
      original.aspect_ratio.first.should            == "4:3"

      # Preservation: Audio essence track fields
      original.audio_standard.first.should          == "Linear PCM Audio"
      original.audio_encoding.first.should          == "in24"
      original.audio_bit_rate.first.should          == "1152"
      original.audio_bit_rate_units.first.should    == "Kbps"
      original.audio_sample_rate.first.should       == "48"
      original.audio_sample_rate_units.first.should == "kHz"
      original.audio_bit_depth.first.should         == "24"
      original.audio_channels.first.should          == "2"

      # Access file
      access = ExternalVideo.find(ing.parent.videos[:access].first.pid)

      # Access: Instantiation fields
      access.date.first.should                    == "2011-10-12"
      access.vendor.first.should                  == "George Blood Audio and Video"
      access.file_format.first.should             == "mp4"
      access.trans_soft.first.should              == "MPEG Streamclip 1.92"
      access.trans_note.first.should              be_nil
      access.operator.first.should                == "TMu"
      access.chroma.first.should                  == "4:2:0"
      access.color_space.first.should             == "YUV"
      access.duration.first.should                == "0:50:47"
      access.colors.first.should                  == "Color"
      access.generation.first.should              == "Copy: access"
      access.media_type.first.should              == "Moving image"

      # Access: Video essence track fields
      access.video_standard.first.should          == "NTSC"
      access.video_encoding.first.should          == "H.264/MPEG-4 AVC"
      access.video_bit_rate.first.should          == "2507"
      access.video_bit_rate_units.first.should    == "Kbps"
      access.video_bit_depth.first.should         == "8"
      access.frame_rate.first.should              == "29.97"
      access.frame_size.first.should              == "640x480"
      access.aspect_ratio.first.should            == "4:3"

      # Access: Audio essence track fields
      access.audio_standard.first.should          == "AAC"
      access.audio_encoding.first.should          == "MPEG-4: AAC"
      access.audio_bit_rate.first.should          == "256"
      access.audio_bit_rate_units.first.should    == "Kbps"
      access.audio_sample_rate.first.should       == "48.0"
      access.audio_sample_rate_units.first.should == "kHz"
      access.audio_bit_depth.first.should         == "16"
      access.audio_channels.first.should          == "2"

    end

    it "should update the metadata from the GBV xml file" do
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], @sip.pid.gsub(/:/,"_")))
      ing = Workflow::GbvIngest.new(copy)
      ing.update

      # Check metadata
      tape = ing.parent.videos[:original].first
      tape.date.first.should == "2007-07-09"

      original = ExternalVideo.find(ing.parent.videos[:preservation].first.pid)
      original.date.first.should            == "2011-10-12"
      original.vendor.first.should          == "George Blood Audio and Video"
      original.cleaning.first.should        be_nil
      original.condition.first.should       == "Bars and tone at end of program"
      original.file_format.first.should     == "mov"
      original.video_encoding.first.should  == "AJA v210"
      original.capture_soft.first.should    == "Apple FCP 7 (ver 7.0.3)"
      original.operator.first.should        == "TMu"

      access = ExternalVideo.find(ing.parent.videos[:access].first.pid)
      access.vendor.first.should            == "George Blood Audio and Video"
      access.file_format.first.should       == "mp4"
      access.audio_encoding.first.should    == "MPEG-4: AAC"
      access.audio_bit_depth.first.should   == "16"
      access.trans_soft.first.should        == "MPEG Streamclip 1.92"
      access.trans_note.first.should        be_nil
      access.operator.first.should          == "TMu"
    end

    it "should not add additional files" do
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], @sip.pid.gsub(/:/,"_")))
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.external_videos.length.should == 3
      tape         = ing.parent.videos[:original].first.pid
      old_original = ing.parent.videos[:preservation].first.pid
      old_h264     = ing.parent.videos[:access].first.pid
      ing.process
      ing.parent.external_videos.length.should == 3
      tape.should         == ing.parent.videos[:original].first.pid
      old_original.should == ing.parent.videos[:preservation].first.pid
      old_h264.should     == ing.parent.videos[:access].first.pid
    end

    it "should reprocess a sip by removing existing video files, re-adding them, and retaining the original tape object" do
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], @sip.pid.gsub(/:/,"_")))
      lambda { copy.prepare }.should raise_error(RuntimeError)
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.external_videos.length.should == 3
      tape         = ing.parent.videos[:original].first.pid
      old_original = ing.parent.videos[:preservation].first.pid
      old_h264     = ing.parent.videos[:access].first.pid
      ing.reprocess
      ing.parent.external_videos.length.should == 3
      tape.should             == ing.parent.videos[:original].first.pid
      old_original.should_not == ing.parent.videos[:preservation].first.pid
      old_h264.should_not     == ing.parent.videos[:access].first.pid

      # Clean-up
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], @sip.pid.gsub(/:/,"_")))
    end

  end

end
