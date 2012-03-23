require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArchivalVideo do

  describe "creating new objects" do

    before(:each) do
      @video = ArchivalVideo.new nil
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
        node, index = @video.insert_node("contributor")
        index.should == 0
      end
    end

    describe "#remove_node" do
      it "should remove a node from the existing xml" do
        node, index = @video.insert_node("contributor")
        index.should == 0
        @video.remove_node("contributor","0")
      end
    end

    describe "apply_depositor_metadata" do
      it "should set depositor info in the properties and rightsMetadata datastreams" do
        rights_ds = @video.datastreams["rightsMetadata"]
        prop_ds = @video.datastreams["properties"]

        node, index = @video.apply_depositor_metadata("Depositor Name")

        prop_ds.depositor_values.should == ["Depositor Name"]
        rights_ds.get_values([:edit_access, :person]).should == ["Depositor Name"]
      end
    end

    describe ".to_solr" do
      it "should index the right fields in solr" do
        solr_doc = @video.to_solr
      end
    end

    describe "delegate fields" do
      it "should be set in the model" do
        @video.reviewer.first.should be_empty
        @video.date_updated.first.should be_empty
        @video.complete.first.should == "no"
        @video.reviewer = "Dufus McGee"
        @video.date_updated = "now"
        @video.reviewer.first.should == "Dufus McGee"
        @video.date_updated.first.should == "now"

      end
    end

  end

  describe "#videos" do
    it "should return a hash of videos" do
      av = ArchivalVideo.load_instance("rockhall:fixture_pbcore_document3")
      av.file_objects.count.should == 2
      av.videos.should be_kind_of(Hash)
    end
  end

  describe "#addl_solr_fields" do
    it "should return a hash of additional fields that will be included in the solr discovery export" do
      av = ArchivalVideo.load_instance("rockhall:fixture_pbcore_document3")
      addl_doc = av.addl_solr_fields
      addl_doc.should be_kind_of(Hash)
      addl_doc.to_s.should match("39156042439369_access.mp4")
      addl_doc.to_s.should match("H.264/MPEG-4 AVC")
    end
  end


end