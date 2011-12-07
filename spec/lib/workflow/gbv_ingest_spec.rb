require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::GbvIngest do

  before(:all) do
    Hydrangea::JettyCleaner.clean(RH_CONFIG["pid_space"])
    solrizer = Solrizer::Fedora::Solrizer.new
    solrizer.solrize_objects
  end

  after(:all) do
    Hydrangea::JettyCleaner.clean(RH_CONFIG["pid_space"])
    solrizer = Solrizer::Fedora::Solrizer.new
    solrizer.solrize_objects
  end

  describe "the entire ingestion process" do

    it "should prepare a sip and ingest it into Fedora" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      FileUtils.cp_r(sip.root,RH_CONFIG["location"])
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.base))
      copy.prepare
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.empty?.should be_true
      ing.process
      ing.parent.file_objects.length.should == 2

      # Check parent object fields
      ing.parent.label.should == "George Blood Audio and Video"
      ds = ing.parent.datastreams_in_memory["descMetadata"]
      ds.get_values([:creation_date]).first.should  == "2007-07-09"
      ds.get_values([:standard]).first.should  == "NTSC"
      ds.get_values([:format]).first.should   == "Betacam"

      # Preservation file
      original = ExternalVideo.load_instance(ing.parent.videos[:original])
      o_ds = original.datastreams_in_memory["descMetadata"]

      # Preservation: Instantiation fields
      o_ds.get_values([:date]).first.should         == "2011-10-12"
      o_ds.get_values([:vendor]).first.should       == "George Blood Audio and Video"
      o_ds.get_values([:cleaning]).first.should     be_nil
      o_ds.get_values([:condition]).first.should    == "Bars and tone at end of program"
      o_ds.get_values([:file_format]).first.should  == "mov"
      o_ds.get_values([:capture_soft]).first.should == "Apple FCP 7 (ver 7.0.3)"
      o_ds.get_values([:operator]).first.should     == "TMu"
      o_ds.get_values([:trans_note]).first.should   be_nil
      o_ds.get_values([:device]).first.should       == "Sony PVW-2800; 20040"
      o_ds.get_values([:chroma]).first.should       == "4:2:2"
      o_ds.get_values([:color_space]).first.should  == "YUV"
      o_ds.get_values([:duration]).first.should     == "0:50:47"
      o_ds.get_values([:colors]).first.should       == "Color"
      o_ds.get_values([:generation]).first.should   == "Copy: preservation"
      o_ds.get_values([:media_type]).first.should   == "Moving image"

      # Preservation: Video essence track fields
      o_ds.get_values([:video_standard]).first.should        == "NTSC"
      o_ds.get_values([:video_encoding]).first.should        == "AJA v210"
      o_ds.get_values([:video_bit_rate]).first.should        == "224"
      o_ds.get_values([:video_bit_rate_units]).first.should == "Mbps"
      o_ds.get_values([:video_bit_depth]).first.should       == "10"
      o_ds.get_values([:frame_rate]).first.should      == "29.97"
      o_ds.get_values([:frame_size]).first.should      == "720x486"
      o_ds.get_values([:aspect_ratio]).first.should           == "4:3"

      # Preservation: Audio essence track fields
      o_ds.get_values([:audio_standard]).first.should            == "Linear PCM Audio"
      o_ds.get_values([:audio_encoding]).first.should            == "in24"
      o_ds.get_values([:audio_bit_rate]).first.should            == "1152"
      o_ds.get_values([:audio_bit_rate_units]).first.should     == "Kbps"
      o_ds.get_values([:audio_sample_rate]).first.should         == "48"
      o_ds.get_values([:audio_sample_rate_units]).first.should  == "kHz"
      o_ds.get_values([:audio_bit_depth]).first.should           == "24"
      o_ds.get_values([:audio_channels]).first.should      == "2"


      # Access file
      access = ExternalVideo.load_instance(ing.parent.videos[:h264])
      a_ds = access.datastreams_in_memory["descMetadata"]

      # Access: Instantiation fields
      a_ds.get_values([:date]).first.should         == "2011-10-12"
      a_ds.get_values([:vendor]).first.should       == "George Blood Audio and Video"
      a_ds.get_values([:file_format]).first.should  == "mp4"
      a_ds.get_values([:trans_soft]).first.should   == "MPEG Streamclip 1.92"
      a_ds.get_values([:trans_note]).first.should   be_nil
      a_ds.get_values([:operator]).first.should     == "TMu"
      a_ds.get_values([:chroma]).first.should       == "4:2:0"
      a_ds.get_values([:color_space]).first.should  == "YUV"
      a_ds.get_values([:duration]).first.should     == "0:50:47"
      a_ds.get_values([:colors]).first.should       == "Color"
      a_ds.get_values([:generation]).first.should   == "Copy: access"
      a_ds.get_values([:media_type]).first.should   == "Moving image"

      # Access: Video essence track fields
      o_ds.get_values([:video_standard]).first.should        == "NTSC"
      a_ds.get_values([:video_encoding]).first.should        == "H.264/MPEG-4 AVC"
      a_ds.get_values([:video_bit_rate]).first.should        == "2507"
      a_ds.get_values([:video_bit_rate_units]).first.should == "Kbps"
      a_ds.get_values([:video_bit_depth]).first.should       == "8"
      a_ds.get_values([:frame_rate]).first.should      == "29.97"
      a_ds.get_values([:frame_size]).first.should      == "640x480"
      a_ds.get_values([:aspect_ratio]).first.should           == "4:3"

      # Access: Audio essence track fields
      a_ds.get_values([:audio_standard]).first.should            == "AAC"
      a_ds.get_values([:audio_encoding]).first.should            == "MPEG-4: AAC"
      a_ds.get_values([:audio_bit_rate]).first.should            == "256"
      a_ds.get_values([:audio_bit_rate_units]).first.should     == "Kbps"
      a_ds.get_values([:audio_sample_rate]).first.should         == "48.0"
      a_ds.get_values([:audio_sample_rate_units]).first.should  == "kHz"
      a_ds.get_values([:audio_bit_depth]).first.should           == "16"
      a_ds.get_values([:audio_channels]).first.should      == "2"

    end

    it "should update the metadata from the GBV xml file" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      ing = Workflow::GbvIngest.new(copy)
      ing.update

      # Check metadata
      ds = ing.parent.datastreams_in_memory["descMetadata"]
      ds.get_values([:creation_date]).first.should == "2007-07-09"

      original = ExternalVideo.load_instance(ing.parent.videos[:original])
      o_ds = original.datastreams_in_memory["descMetadata"]
      o_ds.get_values([:date]).first.should == "2011-10-12"
      o_ds.get_values([:vendor]).first.should == "George Blood Audio and Video"
      o_ds.get_values([:cleaning]).first.should be_nil
      o_ds.get_values([:condition]).first.should == "Bars and tone at end of program"
      o_ds.get_values([:file_format]).first.should == "mov"
      # Preservation video codec
      o_ds.get_values([:video_encoding]).first.should == "AJA v210"
      o_ds.get_values([:capture_soft]).first.should == "Apple FCP 7 (ver 7.0.3)"
      o_ds.get_values([:operator]).first.should == "TMu"

      access = ExternalVideo.load_instance(ing.parent.videos[:h264])
      a_ds = access.datastreams_in_memory["descMetadata"]
      a_ds.get_values([:vendor]).first.should == "George Blood Audio and Video"
      a_ds.get_values([:file_format]).first.should == "mp4"
      # Access audio codec
      a_ds.get_values([:audio_encoding]).first.should == "MPEG-4: AAC"
      # Access audio bit depth
      a_ds.get_values([:audio_bit_depth]).first.should == "16"
      a_ds.get_values([:trans_soft]).first.should == "MPEG Streamclip 1.92"
      a_ds.get_values([:trans_note]).first.should be_nil
      a_ds.get_values([:operator]).first.should == "TMu"
    end

    it "should not add additional files" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.length.should == 2
      first_pid = ing.parent.file_objects.first.pid
      last_pid  = ing.parent.file_objects.last.pid
      ing.process
      ing.parent.file_objects.length.should == 2
      first_pid.should == ing.parent.file_objects.first.pid
      last_pid.should  == ing.parent.file_objects.last.pid
    end

    it "should reprocess a sip by removing existing files and re-adding them" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      lambda { copy.prepare }.should raise_error(RuntimeError)
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.length.should == 2
      first_pid = ing.parent.file_objects.first.pid
      last_pid  = ing.parent.file_objects.last.pid
      ing.reprocess
      ing.parent.file_objects.length.should == 2
      first_pid.should_not == ing.parent.file_objects.first.pid
      last_pid.should_not  == ing.parent.file_objects.last.pid

      # Clean-up
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
    end

  end

end
