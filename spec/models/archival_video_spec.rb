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
    it "should fields specifically for Blacklight" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      solr_doc = doc.to_discovery
      solr_doc["access_file_s"].should == ["39156042439369_access.mp4"]
      solr_doc["format_dtl_display"].should == ["H.264/MPEG-4 AVC"]
      solr_doc["heading_display"].should == doc.title
      solr_doc["format"].should == "Video"
    end

    it "should add additional fields for integration with our finding aids" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document1")
      solr_doc = doc.to_discovery
      solr_doc[Solrizer.solr_name("heading", :displayable)].should == [doc.title] 
      solr_doc[Solrizer.solr_name("ead", :stored_sortable)].should == "RG-0010"
      solr_doc[Solrizer.solr_name("ref", :stored_sortable)].should == "rockhall:fixture_pbcore_document1"
      solr_doc[Solrizer.solr_name("parent", :displayable)].should == ["ref42"]
      solr_doc[Solrizer.solr_name("parent", :stored_sortable)].should == "ref42"
      solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].should == ["Series III: Audiovisual materials"]

    end

    it "should include digital files and formats" do
      doc = ArchivalVideo.find("rrhof:525")
      solr_doc = doc.to_discovery
      solr_doc[Solrizer.solr_name("access_file", :displayable)].should == ["39156042459755_access.mp4"]
      solr_doc[Solrizer.solr_name("format_dtl", :displayable)].should == ["H.264/MPEG-4 AVC"]
    end

    it "should add additional facets" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document3")
      solr_doc = doc.to_discovery
      solr_doc[Solrizer.solr_name("material", :facetable)].should == ["Digital"]
      solr_doc[Solrizer.solr_name("format", :facetable)].should == ["Video"]
      solr_doc[Solrizer.solr_name("material", :displayable)].should == ["Digital"]
      solr_doc[Solrizer.solr_name("format", :displayable)].should == ["Video"]
    end
    
    it "should return correctly formatted contributors" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document1").to_discovery
      doc[Solrizer.solr_name("name", :facetable)].should include "Springsteen, Bruce"
      doc[Solrizer.solr_name("name", :facetable)].should include "Rock and Roll Hall of Fame Foundation"
      doc[Solrizer.solr_name("contributors", :displayable)].should include "Springsteen, Bruce"
      doc[Solrizer.solr_name("contributors", :displayable)].should include "Rock and Roll Hall of Fame Foundation"
    end

    it "should combine collection and additional_collection fields" do
      doc = ArchivalVideo.find("rockhall:fixture_pbcore_document1").to_discovery
      doc[Solrizer.solr_name("collection", :facetable)].should include "Rock and Roll Hall of Fame Foundation Records"
      doc[Solrizer.solr_name("collection", :facetable)].should include "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
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

  describe "collection ids" do

    before :each do
      @video = ArchivalVideo.new
    end

    describe "#ead_id" do
      it "should be the ead for a linked collection" do
        @video.new_collection({:name => "Collection name", :ref => "http://www.place.com/foo/bar"})
        @video.ead_id.should == "bar"
      end
      it "should be nil" do
        @video.ead_id.should be_nil
      end
    end

    describe "#ref_id" do
      it "should be the ref id for a linked collection" do
        @video.new_archival_series({:name => "Series name", :ref => "http://www.place.com/foo/bar"})
        @video.ref_id.should == "bar"
      end
      it "should be nil" do
        @video.ref_id.should be_nil
      end
    end

  end

end