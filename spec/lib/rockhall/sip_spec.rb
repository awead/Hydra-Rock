require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"

describe Rockhall::Sip do

  before(:each) do
    @sip = Rockhall::Sip.new
  end

  describe "#add_package" do

    it "should add the package to a blank SIP" do
      package = "spec/fixtures/rockhall/sips/rockhall_fixture_pbcore_document1"
      @sip.add(package).should be_true
      @sip.pid.should == "rockhall:fixture_pbcore_document1"
      @sip.root.should == package
    end

    it "should fail when called on the wrong content type" do
      package = Dir.new("spec/fixtures/rockhall/sips/rockhall_fixture_mods_image1")
      lambda { @sip.add_package(package) }.should raise_error
      @sip.pid.should be_nil
    end

  end

  describe "#store" do

    it "should store a data file of the sip's class" do
      package = "spec/fixtures/rockhall/sips/rockhall_fixture_pbcore_document1"
      @sip.add(package)
      @sip.store.should be_true
    end


  end


  describe ".load" do

    it "should load a sip from a saved data file" do
      package = "spec/fixtures/rockhall/sips/rockhall_fixture_pbcore_document1"
      sip = Rockhall::Sip.load(package)
      sip.valid?.should be_true
      sip.preservation.should == "rrhof_preservation_10bit.avi"
      sip.access_hq.should == "rrhof_access_h264_high.avi"
      sip.access_lq.should == "rrhof_access_h264_low.avi"
    end

  end

  describe "#valid?" do

    it "should return true when sip is valid" do
      package = "spec/fixtures/rockhall/sips/rockhall_fixture_pbcore_document1"
      @sip.add(package)
      @sip.valid?.should be_true
      @sip.preservation.should == "rrhof_preservation_10bit.avi"
      @sip.access_hq.should == "rrhof_access_h264_high.avi"
      @sip.access_lq.should == "rrhof_access_h264_low.avi"
    end

    it "should return false when any file is mis-named" do
    end

    it "should return false when any file is the wrong type" do
    end

    it "should return false when files are missing" do
    end

  end

  describe "#remove" do
    it "should remove the SIP path from the filesystem" do
    end

  end

  describe "#status" do
    it "should return 'successfully ingested' if ingest is complete" do
    end

    it "should return last error message on failed ingest" do
    end

    it "should abort and return false if sip is invalid" do
    end

    it "should return 'incomplete' on incomplete ingests" do
    end

  end

  describe "#contents" do
    it "should list contents of the sip" do
    end
  end

end
