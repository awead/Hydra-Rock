require 'spec_helper'

describe GenericFile do

  before :each do
    @file = GenericFile.new nil
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
    it "should require a title to save the file" do
      @file.save.should be_false
      @file.title = "My title"
      @file.save.should be_true
    end
  end

  describe "using templates to manage multi-valued terms" do
    it "should insert contributors" do
      @file.new_contributor({:name=> "Name", :role => "role"})
      @file.contributor_name.should == ["Name"]
      @file.contributor_role.should == ["role"]
      @file.new_contributor({:name=> "Name2", :role => "role2"})
      @file.contributor_name.should == ["Name", "Name2"]
      @file.contributor_role.should == ["role", "role2"]
    end

    it "should remove contributors" do
      @file.new_contributor({:name=> "Name", :role => "role"})
      @file.new_contributor({:name=> "Name2", :role => "role2"})
      @file.contributor_name.should == ["Name", "Name2"]
      @file.contributor_role.should == ["role", "role2"]
      @file.delete_contributor(0)
      @file.contributor_name.should == ["Name2"]
      @file.contributor_role.should == ["role2"]
    end
  end

  describe "#sanitize_attributes" do
    it "should use the model's attr_accessible to define allowable fields" do
      params = {:title => "foo", :alternative_title => ["foo", "bar"]}
      @file.sanitize_attributes(params).should == params
    end
  end

end