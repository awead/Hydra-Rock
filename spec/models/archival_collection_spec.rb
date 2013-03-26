require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArchivalCollection do

  describe "creating new objects" do

    before(:each) do
      @coll = ArchivalCollection.new nil
    end

    it "Should be a kind of ActiveFedora::Base" do
      @coll.should be_kind_of(ActiveFedora::Base)
    end

  end

  describe "the test collection" do

    before(:all) do
      @coll = ArchivalCollection.find("arc:test")
      @ref3 = ArchivalComponent.find("arc:test-ref3")
      @ref4 = ArchivalComponent.find("arc:test-ref4")
      @ref6 = ArchivalComponent.find("arc:test-ref6")
    end

    it "should have a collection with components, and components in a collection" do
      @coll.series.length.should == 3
      @coll.series_ids.should =~ ["arc:test-ref3", "arc:test-ref4", "arc:test-ref6"]
      @ref3.collection.pid.should == "arc:test"
      @ref4.collection.pid.should == "arc:test"
      @ref6.collection.pid.should == "arc:test"
    end

    it "should have components with subseries" do
      @ref3.series.should be_nil
      @ref3.sub_series.first.pid.should == "arc:test-ref4"
      @ref4.series.pid.should == "arc:test-ref3"
    end

    it "should have titles" do
      @ref4.title.should == "Subseries A: Sample subseries"
      @coll.title.should == "Test Collection"
    end

    it "should have components with items" do
      pending "Need to update archival video fixtures"
      @ref4.item_ids.should == ["rockhall:fixture_pbcore_digital_document1"]
    end

    it "should have items in the collection" do
      pending "Need to update archival video fixtures"
      @coll.item_ids.length.should == 4
      @coll.item_ids.should include "rockhall:fixture_pbcore_document1"
    end

  end

end