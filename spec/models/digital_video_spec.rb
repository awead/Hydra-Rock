require "spec_helper"

describe DigitalVideo do

  describe "creating new objects" do

    before(:each) do
      @video = DigitalVideo.new nil
    end

    it "Should be a kind of ActiveFedora::Base" do
      @video.should be_kind_of(ActiveFedora::Base)
    end

    it "should include Hydra Model Methods" do
      @video.class.included_modules.should include(Hydra::ModelMethods)
      @video.should respond_to(:apply_depositor_metadata)
    end

    describe "using templates to manage multi-valued terms" do
      it "should insert contributors" do
        @video.new_contributor({:name=> "Name", :role => "role"})
        @video.contributor_name.should == ["Name"]
        @video.contributor_role.should == ["role"]
        @video.new_contributor({:name=> "Name2", :role => "role2"})
        @video.contributor_name.should == ["Name", "Name2"]
        @video.contributor_role.should == ["role", "role2"]
      end

      it "should remove contributors" do
        @video.new_contributor({:name=> "Name", :role => "role"})
        @video.new_contributor({:name=> "Name2", :role => "role2"})
        @video.contributor_name.should == ["Name", "Name2"]
        @video.contributor_role.should == ["role", "role2"]
        @video.delete_contributor(0)
        @video.contributor_name.should == ["Name2"]
        @video.contributor_role.should == ["role2"]
      end
    end

    describe "apply_depositor_metadata" do
      it "should set depositor info in the properties and rightsMetadata datastreams" do
        rights_ds = @video.datastreams["rightsMetadata"]
        @video.apply_depositor_metadata("Depositor Name")
        @video.depositor.should == ["Depositor Name"]
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

  describe "relationships" do
    it "should return a hash of external videos" do
      dv = DigitalVideo.find("rockhall:fixture_pbcore_digital_document1")
      dv.external_videos.count.should == 6
      dv.external_videos.first.should be_kind_of(ExternalVideo)
    end
  end

  describe "#addl_solr_fields" do
    it "should return a hash of additional fields that will be included in the solr discovery export" do
      dv = DigitalVideo.find("rockhall:fixture_pbcore_digital_document1")
      addl_doc = dv.addl_solr_fields
      addl_doc.should be_kind_of(Hash)
      addl_doc[:access_file_s].should be_kind_of(Array)
      addl_doc[:access_file_s].sort.should == ["content_001_access.mp4", "content_002_access.mp4", "content_003_access.mp4"]
      # TODO: get fields from mediainfo into PBCore
      #addl_doc[:format_dtl_display].should == [["H.264/MPEG-4 AVC"]]
    end
  end


end