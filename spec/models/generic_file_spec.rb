require 'spec_helper'

describe GenericFile do

  before :each do
    @file = GenericFile.new
    @file.apply_depositor_metadata "mrfoo@rockhall.org"
  end

  it "should have depositor metadata" do
    @file.depositor.should == "mrfoo@rockhall.org"
  end

  it "should have a pbcore descriptive metadata" do
    @file.title = "My Title"
    @file.descMetadata.to_solr["title_ssm"].should == ["My Title"] 
  end

  it "should have an PbcoreGenericFileDatastream for descMetadata" do
    @file.descMetadata.should be_kind_of PbcoreGenericFileDatastream
  end

  describe "saving" do
    after :each do
      @file.delete
    end
    it "should save the file" do
      @file.save.should be_true
    end

  end

end