require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::GbvIngest do

  before(:each) do
    @sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/11111111")
    @ing = Workflow::GbvIngest.new(@sip)
  end

  after(:each) do
    av = ArchivalVideo.load_instance(@sip.pid)
    av.remove_file_objects
    ActiveFedora::Base.load_instance(@sip.pid).delete
  end

  describe "initialize" do

    it "should initialize a new sip" do
      @ing.sip.should be_a_kind_of(Workflow::GbvSip)
      @ing.parent.should be_a_kind_of(ArchivalVideo)
      @ing.sip.pid.should == @ing.parent.pid
      @ing.parent.file_objects.should be_empty
    end

  end

  describe "processing new sips" do

    it "should process a sip" do
      @ing.process.should be_true
      @ing.parent.file_objects.count.should == 2
      @ing.parent.file_objects.first.label.should == "h264"
      @ing.parent.file_objects.last.label.should == "original"
    end

  end

  describe "dealing with existing content" do

    before(:each) do
      @ing.process
    end

    it "should re-process an existing sip" do

      # Get a list of existing objects, both parent and children
      pidList = Array.new
      pidList << @ing.parent.pid
      @ing.parent.file_objects.each { |obj| pidList << obj.pid }

      # Forcing a new ingest shoud remove all existing objects
      new_ingest = Workflow::GbvIngest.new(@sip,{:force=>TRUE})
      pidList.each do |pid|
        lambda { ActiveFedora::Base.load_instance(pid) }.should raise_error(ActiveFedora::ObjectNotFoundError)
      end

      # And reprocess
      new_ingest.process.should be_true
      new_ingest.parent.file_objects.count.should == 2

    end

    it "should raise an exeception if the destination file exists" do
      @ing = Workflow::GbvIngest.new(@sip)
      lambda { @ing.process }.should raise_error(RuntimeError)
    end

  end


  # is there an object in the Fedora already with this sip?
  #  - pass a field and value to search
  #  - create the object if there isn't
  #  - abort if the object already has video (unless force option)

  # force option:
  #  - removes existing video objects from fedora and the filesystem?
  #  - re-runs

  # attach external video content to main object



end