require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::RockhallSip do

  before(:each) do
    @sip = Workflow::RockhallSip.new("spec/fixtures/rockhall/sips/digital_video_sip")
  end

  describe "creating a new sip" do
    it "should intialize a valid sip from an existing directory" do
      @sip.should be_a_kind_of(Workflow::RockhallSip)
      @sip.valid?.should be_true
    end
  end

  describe "an invalid sip" do

      before(:each) do
        FileUtils.mkdir("tmp/invalid_sip") unless File.directory?("tmp/invalid_sip")
        @invalid = Workflow::RockhallSip.new("tmp/invalid_sip")
      end

      it "should not be valid" do
        @invalid.should be_a_kind_of(Workflow::RockhallSip)
        @invalid.valid?.should be_false
      end


      it "should have a nill access files and preservation files" do
        @invalid.preservation.should be_nil
        @invalid.access.should be_nil
      end

      it "should return false when prepared" do
        lambda { @invalid.prepare }.should raise_error(RuntimeError)
      end

  end

  describe "a valid sip" do

    it "should have three access files" do
      @sip.access.length.should == 3
    end

    it "should have three preservation files" do
      @sip.preservation.length.should == 3
    end

  end

  describe "preparing a sip" do

    before(:each) do
      Hydrangea::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    after(:each) do
      Hydrangea::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    it "should prepare it for ingestion" do
      FileUtils.cp_r(@sip.root,RH_CONFIG["location"])
      copy = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], @sip.base))
      copy.valid?.should be_true
      copy.pid.should be_nil
      copy.prepare
      copy.base.should == copy.pid.gsub(/:/,"_")
      copy_check = Workflow::RockhallSip.new(File.join(RH_CONFIG["location"], copy.base))
      copy_check.valid?.should be_true
      copy_check.pid.should == copy.pid
      FileUtils.rm_rf(File.join(RH_CONFIG["location"], copy.base))
    end

  end

  describe "reusing a sip" do

    after(:each) do
      Hydrangea::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    it "should use the previously defined pid" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
      sip.base = RH_CONFIG["pid_space"] + "_10"
      sip.reuse
      sip.pid.should == RH_CONFIG["pid_space"] + ":10"
    end
  end


end
