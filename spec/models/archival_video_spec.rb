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

    describe "apply_reviewer_metadata" do
      it "should apply username and current date to assetReview datastream" do
        review_ds = @video.datastreams["assetReview"]
        fields = ['reviewer', 'date_completed', 'complete', 'date_updated', 'license', 'abstract'].each do |f|
            review_ds.get_values(f.to_sym).first.should be_nil
        end
        @video.apply_reviewer_metadata("reviewer1@example.com")
        date = DateTime.now
        review_ds.get_values(:reviewer).first.should == "reviewer1@example.com"
        review_ds.get_values(:date_completed).first.should be_nil
        review_ds.get_values(:date_updated).first.should == date.strftime("%Y-%m-%d")
        review_ds.get_values(:license).first.should be_nil
        review_ds.get_values(:abstract).first.should be_nil
      end

    end

    describe ".to_solr" do
      it "should index the right fields in solr" do
        solr_doc = @video.to_solr
      end
    end

    describe "delegate fields" do
      it "should be set in the model" do
        @video.reviewer.should be_empty
        @video.date_updated.should be_empty
        @video.date_completed.should be_empty
        @video.complete.should be_empty
        @video.reviewer = "Dufus McGee"
        @video.date_updated = "now"
        @video.date_completed = "now"
        @video.complete = "yes"
        @video.reviewer.first.should == "Dufus McGee"
        @video.date_updated.first.should == "now"
        @video.date_completed.first.should == "now"
        @video.complete.first.should == "yes"
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


end