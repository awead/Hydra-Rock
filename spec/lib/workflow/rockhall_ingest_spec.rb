require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::RockhallIngest do

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
      sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/digital_video_sip")
      FileUtils.cp_r(sip.root,RH_CONFIG["location"])
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], sip.base))
      copy.prepare
      ing = Workflow::RockhallIngest.new(copy)
      ing.parent.file_objects.empty?.should be_true
      ing.process
      ing.parent.file_objects.length.should == 4

      # Check parent object fields
      ing.parent.label.should == "Rock and Roll Hall of Fame Library and Archives"
      ds = ing.parent.datastreams["descMetadata"]

      # Check any parent field values here...
      # ds.get_values([:field_name]).first.should  == "expected value"

      # Loop through all the files and check fields

    end

    it "should update the metadata from the GBV xml file" do
      pending "Not sure what metadata should be updated since we're not using any xml files"
      sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      ing = Workflow::RockhallIngest.new(copy)
      ing.update

      # Check metadata
      ds = ing.parent.datastreams["descMetadata"]
      ds.get_values([:creation_date]).first.should == "2007-07-09"

      original = ExternalVideo.load_instance(ing.parent.videos[:original])
      o_ds = original.datastreams["descMetadata"]
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
      a_ds = access.datastreams["descMetadata"]
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
      pending "It probably should add additional files..."
      sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      ing = Workflow::RockhallIngest.new(copy)
      ing.parent.file_objects.length.should == 2
      first_pid = ing.parent.file_objects.first.pid
      last_pid  = ing.parent.file_objects.last.pid
      ing.process
      ing.parent.file_objects.length.should == 2
      first_pid.should == ing.parent.file_objects.first.pid
      last_pid.should  == ing.parent.file_objects.last.pid
    end

    it "should reprocess a sip by removing existing files and re-adding them" do
      pending
      sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      lambda { copy.prepare }.should raise_error(RuntimeError)
      ing = Workflow::RockhallIngest.new(copy)
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
