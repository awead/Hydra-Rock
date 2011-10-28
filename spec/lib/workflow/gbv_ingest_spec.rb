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

    it "should prepare a sip and ingest in into Fedora" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      FileUtils.cp_r(sip.root,RH_CONFIG["location"])
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.base))
      copy.prepare
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.empty?.should be_true
      ing.process
      ing.parent.file_objects.length.should == 2
    end

    it "should not add additional files" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      copy.prepare.should be_false
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.length.should == 2
      first_pid = ing.parent.file_objects.first.pid
      last_pid  = ing.parent.file_objects.last.pid
      ing.process
      ing.parent.file_objects.length.should == 2
      first_pid.should == ing.parent.file_objects.first.pid
      last_pid.should  == ing.parent.file_objects.last.pid
    end

    it "should remove existing files and re-add them when forced" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      copy = Workflow::GbvSip.new(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
      copy.prepare.should be_false
      ing = Workflow::GbvIngest.new(copy)
      ing.parent.file_objects.length.should == 2
      first_pid = ing.parent.file_objects.first.pid
      last_pid  = ing.parent.file_objects.last.pid
      ing.process({:force => TRUE})
      ing.parent.file_objects.length.should == 2
      first_pid.should_not == ing.parent.file_objects.first.pid
      last_pid.should_not  == ing.parent.file_objects.last.pid

      # Clean-up
      FileUtils.rm_r(File.join(RH_CONFIG["location"], sip.pid.gsub(/:/,"_")))
    end

  end

end