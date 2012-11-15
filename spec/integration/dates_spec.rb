require 'spec_helper'

describe "Dates" do

  before :each do
    @object = ArchivalVideo.new
    @object.main_title = "Test document for date integration"
  end

  after :all do
    Rockhall::JettyCleaner.clean("changeme")
  end

  it "should accept strings as input" do
    @object.creation_date = "2012-11-15"
    @object.save.should be_true
    @object.creation_date.should == ["2012-11-15"]
    @object.datastreams["descMetadata"].to_solr["creation_date_dt"].should == ["2012-11-15T00:00:00Z"]
    @object.datastreams["descMetadata"].to_solr["creation_date_display"].should == ["2012-11-15"]
  end

  it "should accept date objects as input" do
    @object.creation_date = Date.parse("2012-11-15")
    @object.save.should be_true
    @object.creation_date.should == ["2012-11-15"]
    @object.datastreams["descMetadata"].to_solr["creation_date_dt"].should == ["2012-11-15T00:00:00Z"]
    @object.datastreams["descMetadata"].to_solr["creation_date_display"].should == ["2012-11-15"]
  end

  it "should accept empty dates" do
    @object.creation_date = ""
    @object.save.should be_true
    @object.creation_date.should == [""]  
  end
  
end