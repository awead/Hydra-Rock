require "spec_helper"

describe ArchivalVideo do

  describe "creating new objects" do

    before(:each) do
      @video = ArchivalVideo.new nil
    end

    it "Should be a kind of ActiveFedora::Base" do
      @video.should be_kind_of(ActiveFedora::Base)
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

    it "should create a thumbnail" do
      file = image_fixture "rrhof.jpg"
      @video.add_thumbnail(file)
      @video.datastreams["thumbnail"].content.should be_kind_of File
    end

  end

  describe "relationships" do

    before :each do
      @av  = ArchivalVideo.new nil
      @ev1 = ExternalVideo.new nil
      @ev2 = ExternalVideo.new nil
    end

    it "should add external videos as child objects" do
      @av.external_video_ids.should be_empty
      @av.external_videos << @ev1
      @av.external_videos << @ev2
      @av.external_videos.count.should == 2
    end

    it "should return a hash of external video objects" do
      av = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      av.external_videos.count.should == 3
      av.external_videos.first.should be_kind_of(ExternalVideo)
    end
  end

  describe ".to_discovery" do
    it "should return a solr document with metadata for discovery" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      solr_doc = doc.to_discovery
      solr_doc["access_file_s"].should == ["39156042439369_access.mp4"]
      solr_doc["format_dtl_display"].should == ["H.264/MPEG-4 AVC"]
      solr_doc["heading_display"].should == doc.title
      solr_doc["material_facet"].should == "Digital"
    end

    it "should return correctly formatted contributors" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document1").to_discovery
      doc["name_facet"].should include "Joel, Billy"
      doc["name_facet"].should include "Rock and Roll Hall of Fame Foundation"
      doc["contributors_display"].should include "Joel, Billy"
    end
  end

  describe "adding thumbnails to existing videos" do

    it "should attach an image to fixture from a given file" do
      file = image_fixture "rrhof.jpg"
      av = ArchivalVideo.find("rockhall:fixture_pbcore_document1")
      av.add_thumbnail(file)
      av.save
      test = ArchivalVideo.find("rockhall:fixture_pbcore_document1")
      test.datastreams["thumbnail"].mimeType.should == "image/jpeg"
    end

    it "should attempt to use existing access file if none is given" do
      video = ArchivalVideo.new nil
      video.add_thumbnail
      video.get_thumbnail_url.should be_nil
    end


  end

end