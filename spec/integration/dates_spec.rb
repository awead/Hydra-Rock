require 'spec_helper'

describe "Dates" do

  before :each do
    @ev = ExternalVideo.new nil
    @av = ArchivalVideo.new nil
  end

  after :all do
    Rockhall::JettyCleaner.clean("changeme")
  end

  it "should accept strings as input" do
    @ev.date = "2012-11-15"
    @ev.date.should == ["2012-11-15"]
    @ev.datastreams["descMetadata"].to_solr["date_dt"].should == ["2012-11-15T00:00:00Z"]
    @ev.datastreams["descMetadata"].to_solr["date_display"].should == ["2012-11-15"]
  end

  it "should allow for 4-digit date" do
    @ev.date = "1999"
    @ev.to_solr["date_display"].should == ["1999"]
    @ev.to_solr["date_dt"].should == ["1999-01-01T00:00:00Z"]
  end
  it "should use an incomplete date" do
    @ev.date = "2001-12"
    @ev.to_solr["date_display"].should == ["2001-12"]
    @ev.to_solr["date_dt"].should == ["2001-12-01T00:00:00Z"]
  end

  it "should accept date objects as input" do
    pending "I don't think we'll ever pass in data objects"
    @ev.date = Date.parse("2012-11-15")
    @ev.date.should == ["2012-11-15"]
    @ev.datastreams["descMetadata"].to_solr["date_dt"].should == ["2012-11-15T00:00:00Z"]
    @ev.datastreams["descMetadata"].to_solr["date_display"].should == ["2012-11-15"]
  end

  it "should accept empty dates" do
    @ev.date = ""
    @ev.date.should == [""]  
  end
  
end