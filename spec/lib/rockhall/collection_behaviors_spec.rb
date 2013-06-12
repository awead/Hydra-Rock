require "spec_helper"

describe Rockhall::CollectionBehaviors do

  before :each do
    # Mocking the ArchivalCollection model
    class TestCase
      attr_accessor :discovery_id, :title, :errors
      include Rockhall::CollectionBehaviors
    end
    @case = TestCase.new
  end


  describe ".get_title_from_solr" do
    it "should set the object's title to the title_display field from solr" do
      @case.discovery_id = "ARC-0026"
      @case.get_title_from_solr
      @case.title.should == "Doug Fieger Papers" 
    end

    it "should report errors for non-existent solr docs" do
      @case.discovery_id = "foo"
      @case.errors = ActiveModel::Errors.new nil
      @case.get_title_from_solr
      @case.errors.messages[:get_title_from_solr].first.should == "ID foo not found in discovery index"
    end
  end

  describe ".get_components_from_solr" do
    it "should return an array of component pids from solr" do
      @case.discovery_id = "ARC-0026"
      pids = @case.get_components_from_solr
      pids.should be_kind_of(Array)
      pids.length.should == 12
      pids.should include("ARC-0026ref16")
    end

    it "should return an empty array for non-existent solr docs" do
      @case.discovery_id = "asdfasdf"
      @case.get_components_from_solr.should be_empty
    end
  end

  describe ".get_parent_component_from_solr" do
    it "should return the parent id from a given component" do
      @case.discovery_id = "ARC-0026ref16"
      @case.get_parent_component_from_solr.should == "ref4"
    end

    it "should return nil for first level components" do
      @case.discovery_id = "ARC-0026ref1"
      @case.get_parent_component_from_solr.should be_nil
    end

    it "should return nil for non-existent docs" do
      @case.discovery_id = "giggity"
      @case.get_parent_component_from_solr.should be_nil
    end
  end

end