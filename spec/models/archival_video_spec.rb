require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"
require "nokogiri"

describe ArchivalVideo do

  describe "creating new objects" do

    before(:each) do
      Fedora::Repository.stubs(:instance).returns(stub_everything())
      @video = ArchivalVideo.new
    end

    it "Should be a kind of ActiveFedora::Base" do
      @video.should be_kind_of(ActiveFedora::Base)
    end

    it "should include Hydra Model Methods" do
      @video.class.included_modules.should include(Hydra::ModelMethods)
      @video.should respond_to(:apply_depositor_metadata)
    end

    describe "#insert_node" do
      it "should insert a new node into the existing xml" do
        node, index = @video.insert_node("pbcoreContributor")
        index.should == 0
      end
    end

    describe "#remove_node" do
      it "should remove a node from the existing xml" do
        node, index = @video.insert_node("pbcoreContributor")
        index.should == 0
        @video.remove_node("pbcoreContributor","0")
      end
    end

    describe "apply_depositor_metadata" do
      it "should set depositor info in the properties and rightsMetadata datastreams" do
        rights_ds = @video.datastreams_in_memory["rightsMetadata"]
        prop_ds = @video.datastreams_in_memory["properties"]

        node, index = @video.apply_depositor_metadata("Depositor Name")

        prop_ds.depositor_values.should == ["Depositor Name"]
        rights_ds.get_values([:edit_access, :person]).should == ["Depositor Name"]
      end
    end

    describe "apply_reviewer_metadata" do
      it "should update the assetReview datastream for the first time" do
        review_ds = @video.datastreams_in_memory["assetReview"]
        fields = ['reviewer', 'date_completed', 'date_updated', 'license', 'notes'].each do |f|
            review_ds.get_values(f.to_sym).first.should be_nil
        end
        @video.apply_reviewer_metadata("reviewer1@example.com","foo")
        date = DateTime.now
        review_ds.get_values(:reviewer).first.should == "reviewer1@example.com"
        review_ds.get_values(:date_completed).first.should == date.strftime("%Y-%m-%d")
        review_ds.get_values(:date_updated).first.should == date.strftime("%Y-%m-%d")
        review_ds.get_values(:license).first.should == "foo"
        review_ds.get_values(:notes).first.should be_nil
      end

      it "should update the assetReview datastream with a note" do
        @video.apply_reviewer_metadata("reviewer1@example.com","bar",{:notes=>"Notey note"})
        review_ds = @video.datastreams_in_memory["assetReview"]
        review_ds.get_values(:reviewer).first.should == "reviewer1@example.com"
        review_ds.get_values(:license).first.should == "bar"
        review_ds.get_values(:notes).first.should == "Notey note"
      end
    end

    describe ".to_solr" do
      it "should index the right fields in solr" do
        solr_doc = @video.to_solr
      end
    end

  end

  describe "#videos" do
    it "should return a hash of videos" do
      av = ArchivalVideo.load_instance("rockhall:fixture_pbcore_document1")
      av.file_objects.count.should == 2
      av.videos.should be_kind_of(Hash)
    end
  end


end