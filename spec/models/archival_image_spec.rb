require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require "active_fedora"
require "nokogiri"

describe ArchivalImage do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @image = ArchivalImage.new
  end

  it "Should be a kind of ActiveFedora::Base" do
    @image.should be_kind_of(ActiveFedora::Base)
  end

  it "should include Hydra Model Methods" do
    @image.class.included_modules.should include(Hydra::ModelMethods)
    @image.should respond_to(:apply_depositor_metadata)
  end

  it "should have accessors for its default datastreams of content and original" do
    @image.should respond_to(:has_content?)
    @image.should respond_to(:content)
    @image.should respond_to(:content=)
    @image.should respond_to(:has_original?)
    @image.should respond_to(:original)
    @image.should respond_to(:original=)
  end

  it "should have accessors for its default datastreams of max, screen and thumbnail" do
    @image.should respond_to(:has_max?)
    @image.should respond_to(:max)
    @image.should respond_to(:max=)
    @image.should respond_to(:has_screen?)
    @image.should respond_to(:screen)
    @image.should respond_to(:screen=)
    @image.should respond_to(:has_thumbnail?)
    @image.should respond_to(:thumbnail)
    @image.should respond_to(:thumbnail=)
  end

  describe '#content=' do
    it "shoutld create a content datastream when given an image file" do
    end
  end

  describe '#derive_all' do
    it "should create a max, screen and thumbnail file" do
    end
  end

  describe "insert_contributor" do
    it "should generate a new contributor of type (type) into the current xml, treating strings and symbols equally to indicate type, and then mark the datastream as dirty" do
      mods_ds = @image.datastreams_in_memory["descMetadata"]
      mods_ds.expects(:insert_contributor).with("person",{})
      node, index = @image.insert_contributor("person")
    end
  end

  describe "remove_contributor" do
    it "should remove the corresponding contributor from the xml and then mark the datastream as dirty" do
      mods_ds = @image.datastreams_in_memory["descMetadata"]
      mods_ds.expects(:remove_contributor).with("person","3")
      node, index = @image.remove_contributor("person", "3")
    end
  end

  describe "apply_depositor_metadata" do
    it "should set depositor info in the properties and rightsMetadata datastreams" do
      rights_ds = @image.datastreams_in_memory["rightsMetadata"]
      prop_ds = @image.datastreams_in_memory["properties"]

      node, index = @image.apply_depositor_metadata("Depositor Name")

      prop_ds.depositor_values.should == ["Depositor Name"]
      rights_ds.get_values([:edit_access, :person]).should == ["Depositor Name"]
    end
  end
end
