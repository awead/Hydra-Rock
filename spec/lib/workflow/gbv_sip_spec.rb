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
      @sip.data[:access][:h264][:file].should == "11111111_access.mp4"
      @sip.data[:access][:h264][:checksum].should == "1951cfc1a30b453a6e45036e60df4382"
    end

    it "should have a hash of preservation files and checksums" do
      @sip.data[:preservation].should be_a_kind_of(Hash)
      @sip.data[:preservation][:original][:file].should == "11111111_preservation.mov"
      @sip.data[:preservation][:original][:checksum].should == "99140de52a49873a68868037c8afcc5c"
    end

  end


end