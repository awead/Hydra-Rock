require "spec_helper"

describe Workflow::GbvSip do

  before(:each) do
    @sip = Workflow::GbvSip.new(sip "39156042439369")
  end

  describe "creating a new sip" do
    it "should intialize a valid sip from an existing directory" do
      @sip.should be_a_kind_of(Workflow::GbvSip)
      @sip.valid?.should be_true
    end
  end

  describe "an invalid sip" do

      before(:each) do
        FileUtils.mkdir("tmp/invalid_sip") unless File.directory?("tmp/invalid_sip")
        @invalid = Workflow::GbvSip.new("tmp/invalid_sip")
      end

      it "should not be valid" do
        @invalid.should be_a_kind_of(Workflow::GbvSip)
        @invalid.valid?.should be_false
      end

      it "should have a nil xml file" do
        @invalid.doc.should be_nil
      end

      it "should have a nil barcode and title, as well as a nill access and preservation file" do
        @invalid.title.should be_nil
        @invalid.barcode.should be_nil
        @invalid.preservation.should be_nil
        @invalid.access.should be_nil
      end

      it "should return false when prepared" do
        lambda { @invalid.prepare }.should raise_error(RuntimeError)
      end

  end

  describe "a valid sip" do
    it "should have an xml file" do
      @sip.doc.should be_a_kind_of(Workflow::GbvDocument)
    end

    it "should have an access file" do
      @sip.access.should == "39156042439369_access.mp4"
    end

    it "should have a preservation file" do
      @sip.preservation.should == "39156042439369_preservation.mov"
    end

    it "should have a title" do
      @sip.title.should == "Rock-n-Roll Hall of Fame. The craft. Jim James. @ the Belly Up, San Diego. Main mix, stereo. Part 2 of 2."
    end

    it "should have a barcode" do
      @sip.barcode.should == "39156042439369"
    end

  end

  describe "additional metadata from a sip" do

    it "should include fields that are not in MediaInfo" do
      @sip.info(:orig_date).should                == "2007-07-09"
      @sip.info(:standard).should                 == "NTSC"
      @sip.info(:condition).should                == "Bars and tone at end of program"
      @sip.info(:format).should                   == "Betacam"
      @sip.info(:cleaning).should                 be_nil
      @sip.info(:p_name).should                   == "39156042439369_preservation"
      @sip.info(:p_create_date).should            == "2011-10-12" # exemplar from xml is 10/12/2011
      @sip.info(:p_file_format).should            == "mov"
      @sip.info(:p_size).should                   == "86,166.24"
      @sip.info(:p_size_units).should             == "MB"
      @sip.info(:p_duration).should               == "0:50:47"
      @sip.info(:p_video_codec).should            == "AJA v210"
      @sip.info(:p_video_bit_rate).should         == "224"
      @sip.info(:p_video_bit_rate_units).should   == "Mbps"
      @sip.info(:p_video_bit_depth).should        == "10"
      # frame rate pending (see below)
      # frame size pending (see below)
      @sip.info(:p_ratio).should                  == "4:3"
      @sip.info(:p_chroma).should                 == "4:2:2"
      @sip.info(:p_color_space).should            == "YUV"
      @sip.info(:p_audio_encoding).should         == "in24"
      @sip.info(:p_audio_standard).should         == "Linear PCM Audio"
      @sip.info(:p_audio_bit_rate).should         == "1152"
      @sip.info(:p_audio_bit_rate_unit).should    == "Kbps"
      @sip.info(:p_audio_sample_rate).should      == "48"
      # preservation audio same rate units are pending
      @sip.info(:p_audio_bit_depth).should        == "24"
      @sip.info(:p_audio_channels).should         == "2"
      @sip.info(:p_checksum_type).should          == "md5"
      @sip.info(:p_checksum_value).should         == "a8a357f97736e108f01b87b878de2323"
      # device pending (see below)
      @sip.info(:capture_soft).should             == "Apple FCP 7 (ver 7.0.3)"
      @sip.info(:p_trans_note).should             be_nil
      @sip.info(:p_operator).should               == "TMu"
      @sip.info(:p_vendor).should                 == "George Blood Audio and Video"
      @sip.info(:a_name).should                   == "39156042439369_access"
      @sip.info(:a_create_date).should            == "2011-10-12" # exemplar from xml is 10/12/2011
      @sip.info(:a_file_format).should            == "mp4"
      @sip.info(:a_size).should                   == "1,057.96"
      @sip.info(:a_size_units).should             == "MB"
      @sip.info(:a_duration).should               == "0:50:47"
      @sip.info(:a_video_codec).should            == "H.264/MPEG-4 AVC"
      @sip.info(:a_video_bit_rate).should         == "2507"
      @sip.info(:a_video_bit_rate_units).should   == "Kbps"
      @sip.info(:a_video_bit_depth).should        == "8"
      @sip.info(:a_frame_rate).should             == "29.97"
      @sip.info(:a_frame_size).should             == "640x480"
      @sip.info(:a_ratio).should                  == "4:3"
      @sip.info(:a_chroma).should                 == "4:2:0"
      @sip.info(:a_color_space).should            == "YUV"
      @sip.info(:a_audio_standard).should         == "AAC"
      @sip.info(:a_audio_encoding).should         == "MPEG-4: AAC"
      @sip.info(:a_audio_bit_rate).should         == "256"
      @sip.info(:a_audio_bit_rate_unit).should    == "Kbps"
      @sip.info(:a_audio_sample_rate).should      == "48.0"
      @sip.info(:a_audio_sample_rate_unit).should == "kHz"
      @sip.info(:a_audio_bit_depth).should        == "16"
      @sip.info(:a_audio_channels).should         == "2"
      @sip.info(:a_checksum_type).should          == "md5"
      @sip.info(:a_checksum_value).should         == "5441895028acd538cf43ea26459b7f13"
      @sip.info(:trans_soft).should               == "MPEG Streamclip 1.92"
      @sip.info(:a_trans_note).should             be_nil
      @sip.info(:a_operator).should               == "TMu"
      @sip.info(:a_vendor).should                 == "George Blood Audio and Video"
    end

    it "should also have the playback device, video frame rate and frame size" do
      @sip.info(:device).should        == "Sony PVW-2800; 20040"
      @sip.info(:p_frame_rate).should  == "29.97"
      @sip.info(:p_frame_size).should  == "720x486"
      @sip.info(:p_audio_sample_rate_unit).should == "kHz"
    end

  end

  describe "preparing a sip" do

    before(:each) do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    after(:each) do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    it "should prepare it for ingestion" do
      FileUtils.cp_r(@sip.root,RH_CONFIG["location"])
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], @sip.base))
      copy.valid?.should be_true
      copy.pid.should be_nil
      copy.prepare
      copy.base.should == copy.pid.gsub(/:/,"_")
      copy_check = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], copy.base))
      copy_check.valid?.should be_true
      copy_check.pid.should == copy.pid
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], copy.base))
    end

  end

  describe "reusing a sip" do

    after(:each) do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    it "should use the previously defined pid" do
      sip = Workflow::GbvSip.new(sip "39156042439369")
      sip.base = RH_CONFIG["pid_space"] + "_10"
      sip.reuse
      sip.pid.should == RH_CONFIG["pid_space"] + ":10"
    end
  end

  describe "when barcodes are mis-matched" do
    it "the xml barcode does not match the folder name" do
      @sip.barcodes_match?.should be_true
      mismatch = Workflow::GbvSip.new(sip "22222222")
      mismatch.barcodes_match?.should be_false
    end
  end

  describe "when a field is empty" do
    it "the xml will be blank" do
      false_sip = Workflow::GbvSip.new(sip "22222222")
      false_sip.valid?.should be_false
    end
  end

end
