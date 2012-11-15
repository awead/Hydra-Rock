require "spec_helper"

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

    describe "using templates to manage multi-valued terms" do
      it "should insert contributors" do
        @video.new_contributor("Name", "role")
        @video.contributor_name.should == ["Name"]
        @video.contributor_role.should == ["role"]
        @video.new_contributor("Name2", "role2")
        @video.contributor_name.should == ["Name", "Name2"]
        @video.contributor_role.should == ["role", "role2"]
      end

      it "should remove contributors" do
        @video.new_contributor("Name", "role")
        @video.new_contributor("Name2", "role2")
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
      it "should allow for 4-digit date" do
        @video.creation_date = "1999"
        @video.to_solr["creation_date_display"].should == ["1999"]
        @video.to_solr["creation_date_dt"].should == ["1999-01-01T00:00:00Z"]
      end
      it "should use an incomplete date" do
        @video.creation_date = "2001-12"
        @video.to_solr["creation_date_display"].should == ["2001-12"]
        @video.to_solr["creation_date_dt"].should == ["2001-12-01T00:00:00Z"]
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
      av = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      av.file_objects.count.should == 2
      av.videos.should be_kind_of(Hash)
    end
  end

  describe "#addl_solr_fields" do
    it "should return a hash of additional fields that will be included in the solr discovery export" do
      av = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      addl_doc = av.addl_solr_fields
      addl_doc.should be_kind_of(Hash)
      addl_doc[:access_file_s].should be_kind_of(Array)
      addl_doc[:access_file_s].should == ["39156042439369_access.mp4"]
      addl_doc[:format_dtl_display].should == ["H.264/MPEG-4 AVC"]
    end
  end


end