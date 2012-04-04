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
      ing.parent.label.should == "Rock and Roll Hall of Fame Library and Archives"
      ds = ing.parent.datastreams["descMetadata"]

      # Reprocess
      copy_sip = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], copy.pid.gsub(/:/,"_")))
      re_ing = Workflow::RockhallIngest.new(copy_sip)
      re_ing.parent.file_objects.length.should == 6
      #first_pid = ing.parent.file_objects.first.pid
      #last_pid  = ing.parent.file_objects.last.pid
      re_ing.reprocess
      re_ing.parent.file_objects.length.should == 6
      #first_pid.should_not == ing.parent.file_objects.first.pid
      #last_pid.should_not  == ing.parent.file_objects.last.pid

      # Clean-up
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], copy.pid.gsub(/:/,"_")))
    end

  end

end
