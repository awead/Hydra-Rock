require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"
require "nokogiri"

describe ArchivalVideo do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @video = ArchivalVideo.new
  end

  it "Should be a kind of ActiveFedora::Base" do
    @video.should be_kind_of(ActiveFedora::Base)
  end

  it "should include Hydra Model Methods" do
    @video.class.included_modules.should include(Hydra::ModelMethods)
    @video.should respond_to(:apply_depositor_metadata)
  end

  describe "#insert_node" do
    it "should insert a new node into the existing xml" do
      node, index = @video.insert_node("contributor")
      index.should == 0
    end
  end

  describe "#remove_node" do
    it "should remove a node from the existing xml" do
      node, index = @video.insert_node("contributor")
      index.should == 0
      @video.remove_node("contributor","0")
    end
  end

  describe "apply_depositor_metadata" do
    it "should set depositor info in the properties and rightsMetadata datastreams" do
      rights_ds = @video.datastreams_in_memory["rightsMetadata"]
      prop_ds = @video.datastreams_in_memory["properties"]

      node, index = @video.apply_depositor_metadata("Depositor Name")

      prop_ds.depositor_values.should == ["Depositor Name"]
      rights_ds.get_values([:edit_access, :person]).should == ["Depositor Name"]
    end
  end

  describe "#ingest" do

    it "should ingest a valid sip" do
      pending
    end

    it "should not ingest an invalid sip" do
      sip = Rockhall::Sip.new
      lambda { @video.ingest(sip) }.should raise_error
    end

  end

  describe "#external_video" do

    it "should return the file_object with the corresponding datastream label" do
      pending
    end

  end

  describe ".to_solr" do
    it "should index the right fields in solr" do
      solr_doc = @video.to_solr

    end
  end


end