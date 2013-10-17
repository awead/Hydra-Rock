require 'spec_helper'

describe Rockhall::TemplateMethods do

  before :each do
    @sample = ArchivalVideo.new
  end

  describe ".create_node" do
    it "should create a new node with a given params hash" do
      args = {:type => "contributor", :name => "John Doe", :role => "author"}
      @sample.create_node(args)
      @sample.contributor_name.first.should == "John Doe"
      @sample.contributor_role.first.should == "author"
    end

    it "should return an error for non-existent node types" do
      args = {:type => "foo"}
      @sample.create_node(args)
      @sample.errors["node"].first.should == "foo is not defined"      
    end
  end

  describe "adding named nodes" do
    it "should add new contributors" do
      @sample.new_contributor(:name => "foo")
      @sample.contributor_name.first.should == "foo"
      @sample.descMetadata.changed?.should be_true
    end

    it "should add new publishers" do
      @sample.new_publisher(:name => "foo")
      @sample.publisher_name.first.should == "foo"
      @sample.descMetadata.changed?.should be_true
    end
  end

  describe "adding events" do
    it "should add an event series field" do
      args = {:type => "event", :event_type => "series", :event_value => "Some Series"}
      @sample.create_node(args)
      @sample.event_series.first.should == "Some Series"
    end

    it "should add an event place field" do
      args = {:type => "event", :event_type => "place", :event_value => "Some Place"}
      @sample.create_node(args)
      @sample.event_place.first.should == "Some Place"
    end

    it "should add an event date field" do
      args = {:type => "event", :event_type => "date", :event_value => "2001-02-03"}
      @sample.create_node(args)
      @sample.event_date.first.should == "2001-02-03"
    end

    it "should report on invalid dates" do
      args = {:type => "event", :event_type => "date", :event_value => "foo"}
      @sample.create_node(args)
      @sample.errors[:event_date].should == ["Date must be in YYYY-MM-DD format, or YYYY-MM, or just YYYY"]
    end
  end

  describe "maintaining existing nodes" do
    before :each do
      @sample.new_event_series({:event_value => "my series 1"})
      @sample.new_event_place({:event_value => "my place 1"})
      @sample.new_event_date({:event_value => "2001-02-03"})
      @sample.new_event_series({:event_value => "my series 2"})
      @sample.new_event_place({:event_value => "my place 2"})
      @sample.new_event_date({:event_value => "2001-02-04"})
      @sample.new_additional_collection({:name => "Foo Collection"})
    end

    after :each do
      @sample.additional_collection.should == ["Foo Collection"]
    end

    it "should delete existing event series without a given index" do
      @sample.event_series.should == ["my series 1", "my series 2"]
      @sample.delete_event_series
      @sample.event_series.should == ["my series 2"]
    end

    it "should delete existing event series with a given index" do
      @sample.event_series.should == ["my series 1", "my series 2"]
      @sample.delete_event_series 1
      @sample.event_series.should == ["my series 1"]
    end

    it "should delete existing event places without an index" do
      @sample.event_place.should == ["my place 1", "my place 2"]
      @sample.delete_event_place
      @sample.event_place.should == ["my place 2"]
    end

    it "should delete existing event dates without an index" do
      @sample.event_date.should == ["2001-02-03", "2001-02-04"]
      @sample.delete_event_date
      @sample.event_date.should == ["2001-02-04"]
    end
  end

  describe "adding collections" do
    it "should add a collection with a uri and source" do
      @sample.create_node({:type => "collection", :name => "Foo", :ref => "Bar", :source => "Some source"})
      @sample.collection.should == "Foo"
      @sample.collection_uri.should == "Bar"
      @sample.collection_authority.should == "Some source"
    end
    it "should add a collection with just a name" do
      @sample.create_node({:type => "collection", :name => "Blerg"})
      @sample.collection.should == "Blerg"
    end
  end

  describe "adding archival series" do
    it "should add an archival series with a uri and source" do
      @sample.create_node({:type => "archival_series", :name => "Foo", :ref => "Bar", :source => "Some source"})
      @sample.archival_series.should == "Foo"
      @sample.archival_series_uri.should == "Bar"
      @sample.archival_series_authority.should == "Some source"
    end
    it "should add an archival series with just a name" do
      @sample.create_node({:type => "archival_series", :name => "Blerg"})
      @sample.archival_series.should == "Blerg"
    end
  end  

  describe "deleting named nodes" do
    before :each do
      @deleted = ArchivalVideo.new(:pid => "deleted:1")
      @deleted.title = "Deleted sample"
      @deleted.new_contributor(:name => "name1")
      @deleted.new_contributor(:name => "name2")
      @deleted.new_publisher(:name => "pub1")
      @deleted.new_publisher(:name => "pub2")
      @deleted.save
    end

    after :each do
      @deleted.delete
    end

    it "should delete a contributor with a given index and mark the datastream changed" do
      @deleted.descMetadata.changed?.should be_false
      @deleted.delete_contributor(1).should be_true
      @deleted.contributor_name.should == ["name1"]
      @deleted.descMetadata.changed?.should be_true
    end

    it "should delete a publisher without a given index and mark the datastream changed" do
      @deleted.descMetadata.changed?.should be_false
      @deleted.delete_publisher.should be_true
      @deleted.publisher_name.should == ["pub2"]
      @deleted.descMetadata.changed?.should be_true
    end
  end
  
end