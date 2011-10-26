require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::GbvSip do

  before(:each) do
    @sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/39156042439369")
  end

  describe "creating a new sip" do
    it "should intialize a valid sip from an existing directory" do
      @sip.should be_a_kind_of(Workflow::GbvSip)
      @sip.valid?.should be_true
    end

    it "should intialize an invalid sip" do
      sip = Workflow::GbvSip.new("tmp")
      sip.should be_a_kind_of(Workflow::GbvSip)
      sip.valid?.should be_false
    end

  end

  describe "the xml doc" do
    it "should be nil if it doesn't exist" do
      sip = Workflow::GbvSip.new("tmp")
      sip.doc.should be_nil
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


end