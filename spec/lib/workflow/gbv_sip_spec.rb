require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Workflow::GbvSip do

  before(:each) do
    @sip = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/11111111")
  end

  describe "creating a new sip from a path" do
    it "should intialize a valid sip from an existing directory" do
      @sip.should be_a_kind_of(Workflow::GbvSip)
      @sip.valid?.should be_true
    end

    it "should intialize an invalid sip" do
      sip = Workflow::GbvSip.new("spec/fixtures/rockhall")
      sip.should be_a_kind_of(Workflow::GbvSip)
      sip.valid?.should be_false
    end

  end

  describe "the content of a sip" do

    it "should have an xml file" do
      @sip.info[:xml].should == "11111111.xml"
    end

    it "should have a hash of access files and checksums" do
      @sip.data[:access][:h264][:file].should == "11111111_access.avi"
      @sip.data[:access][:h264][:checksum].should == "001b0290f1b323622e475a954bc6caa021904f1c"
    end

    it "should have a hash of preservation files and checksums" do
      @sip.data[:preservation].should be_a_kind_of(Hash)
      @sip.data[:preservation][:original][:file].should == "11111111_pres.avi"
      @sip.data[:preservation][:original][:checksum].should == "5d8b67b8fe684d3602d8706378579e1578201840"
    end

  end

end