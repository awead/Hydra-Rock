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
  end

  describe "an invalid sip" do

      before(:each) do
        @invalid = Workflow::GbvSip.new("tmp")
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
        @invalid.prepare.should be_false
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

  describe "when barcodes are mis-matched" do

    it "the xml barcode does not match the folder name" do
      @sip.barcodes_match.should be_true
      mismatch = Workflow::GbvSip.new("spec/fixtures/rockhall/sips/22222222")
      mismatch.barcodes_match.should be_false
    end

  end
end