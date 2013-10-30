require 'spec_helper'

describe "Dates" do

  before :each do
    @ev = ExternalVideo.new(:pid => "dates-integration:2")
    @av = ArchivalVideo.new(:pid => "dates-integration:1")
  end

  after :all do
    Rockhall.jetty_clean("changeme")
  end

  it "should solrize complete dates" do
    @ev.date = "2012-11-15"
    @ev.date.should == ["2012-11-15"]
    @ev.datastreams["descMetadata"].to_solr["date_dtsim"].should == ["2012-11-15T00:00:00Z"]
    @ev.datastreams["descMetadata"].to_solr["date_ssm"].should == ["2012-11-15"]
  end

  it "should solrize dates withtout a month or day" do
    @ev.date = "1999"
    @ev.to_solr["date_ssm"].should == ["1999"]
    @ev.to_solr["date_dtsim"].should be_empty
  end
  
  it "should solrize dates withtout a day" do
    @ev.date = "2001-12"
    @ev.to_solr["date_ssm"].should == ["2001-12"]
    @ev.to_solr["date_dtsim"].should be_empty
  end

  it "should accept empty dates" do
    @ev.date = ""
    @ev.date.should == [""]  
  end

  it "should index multiple dates" do
    @av.create_node({:type => "event", :event_type => "date", :event_value => "2001-02-03"})
    @av.create_node({:type => "event", :event_type => "date", :event_value => "2001-02-04"})
    @av.event_date.should == ["2001-02-03", "2001-02-04"]
    @av.update_index
  end
  
end