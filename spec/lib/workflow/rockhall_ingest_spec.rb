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

    it "should prepare a sip, ingest it into Fedora, and reprocess it" do
      sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/digital_video_sip")
      FileUtils.cp_r(sip.root,RH_CONFIG["location"])
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], sip.base))
      copy.prepare
      ing = Workflow::RockhallIngest.new(copy)
      ing.parent.file_objects.empty?.should be_true
      ing.process
      ing.parent.file_objects.length.should == 6

      # Check parent object fields
      ing.parent.label.first.should == "Rock and Roll Hall of Fame Library and Archives"

      # Check access videos
      ing.parent.videos[:h264].each do |ev|
        ev.vendor.first.should == "Rock and Roll Hall of Fame Library and Archives"
        ev.label.should == "h264"
        ev.generation.first.should == "Copy: access"
        ev.date.first.should match /^2012/
        ev.size.first.should == "240"
        ev.media_type.first.should == "Moving image"
        ev.colors.first.should == "Color"
      end

      # Check access video order
      ing.parent.videos[:h264][0].name.first.should     == "content_001_access.mp4"
      ing.parent.videos[:h264][0].next.first.should     == "content_002_access.mp4"
      ing.parent.videos[:h264][0].previous.first.should be_nil

      ing.parent.videos[:h264][1].name.first.should     == "content_002_access.mp4"
      ing.parent.videos[:h264][1].next.first.should     == "content_003_access.mp4"
      ing.parent.videos[:h264][1].previous.first.should == "content_001_access.mp4"

      ing.parent.videos[:h264][2].name.first.should     == "content_003_access.mp4"
      ing.parent.videos[:h264][2].next.first.should     be_nil
      ing.parent.videos[:h264][2].previous.first.should == "content_002_access.mp4"

      # Check preservation videos
      ing.parent.videos[:original].each do |ev|
        ev.vendor.first.should == "Rock and Roll Hall of Fame Library and Archives"
        ev.label.should == "original"
        ev.generation.first.should == "original"
        ev.date.first.should match /^2012/
        ev.size.first.first.should == "0"
        ev.media_type.first.should == "Moving image"
        ev.colors.first.should == "Color"
      end

      # Check preservation video order
      ing.parent.videos[:original][0].name.first.should     == "content_001_preservation.mov"
      ing.parent.videos[:original][0].next.first.should     == "content_002_preservation.mov"
      ing.parent.videos[:original][0].previous.first.should be_nil

      ing.parent.videos[:original][1].name.first.should     == "content_002_preservation.mov"
      ing.parent.videos[:original][1].next.first.should     == "content_003_preservation.mov"
      ing.parent.videos[:original][1].previous.first.should == "content_001_preservation.mov"

      ing.parent.videos[:original][2].name.first.should     == "content_003_preservation.mov"
      ing.parent.videos[:original][2].next.first.should     be_nil
      ing.parent.videos[:original][2].previous.first.should == "content_002_preservation.mov"

      # Reprocess
      copy_sip = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], copy.pid.gsub(/:/,"_")))
      re_ing = Workflow::RockhallIngest.new(copy_sip)
      re_ing.parent.file_objects.length.should == 6
      first_pid = re_ing.parent.file_objects.first.pid
      last_pid  = re_ing.parent.file_objects.last.pid
      re_ing.reprocess
      re_ing.parent.file_objects.length.should == 6
      first_pid.should_not == re_ing.parent.file_objects.first.pid
      last_pid.should_not  == re_ing.parent.file_objects.last.pid

      # Clean-up
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], copy.pid.gsub(/:/,"_")))
    end

  end

end
