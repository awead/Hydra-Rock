require 'spec_helper'

describe Rockhall::Reorganize do

  before :each do
    @sample = ArchivalVideo.new(:pid => "reorganize:1")
    @collection = ArchivalCollection.all.first
    @sample.collection = @collection
    @series = ArchivalComponent.all.first
    @sample.series = @series
  end

  describe "#capture_collections" do
    describe "without additional collections" do
      it "saves metadata to the properties datastream" do
        @sample.capture_collections
        @sample.properties.collection_title.first.should == @collection.title
        @sample.properties.series.first.should == @series.title
      end
      it "is idempotent" do
        @sample.capture_collections
        @sample.capture_collections
        @sample.properties.collection_title.first.should == @collection.title
        @sample.properties.series.first.should == @series.title
      end
    end
    describe "with additional collections" do
      before :each do
        @sample.new_collection({:name => "foo"})
      end
      it "saves metadata to the properties datastream" do
        @sample.capture_collections
        @sample.properties.additional_collection.first.should == "foo"
      end
      it "is idempotent" do
        @sample.capture_collections
        @sample.capture_collections
        @sample.properties.additional_collection.first.should == "foo"
      end
    end
  end

  describe "#collections_saved?" do
    it "returns true" do
      @sample.capture_collections
      @sample.collections_saved?.should be_true
    end
    it "returns false" do
      @sample.collections_saved?.should be_false
    end
  end

  describe "#remove_collections" do
    it "removes all collection relationships and metadata" do
      @sample.remove_collections
      @sample.series.should be_nil
      @sample.collection.should be_nil
      @sample.additional_collection.should be_empty
    end
  end

end