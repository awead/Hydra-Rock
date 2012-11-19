require "spec_helper"

describe Rockhall::Discovery do

  before :all do
    @d = Rockhall::Discovery.new
    @d.update
  end

  after :all do
    @d.delete
    @d.blacklight_items.length.should == 0
  end

  it "should create a connection to our Blacklight solr index" do
    @d.solr.should be_a_kind_of(RSolr::Client)
  end

  describe "Items in Hydra" do
    it "should be an array of publically available ActiveFedora model objects" do
      @d.public_items.should be_a_kind_of(Array)
      @d.public_items.count.should == 3
    end
  end

  describe "Items in Blacklight" do

    it "should be take from public_items" do
      @d.blacklight_items.length.should == 3
    end

  end

  describe ".addl_solr_fields" do
    it "should return a list of additional fields for a digital video" do
      fields = @d.addl_solr_fields("rockhall:fixture_pbcore_digital_document1")
      fields[:access_file_s].should == ["content_001_access.mp4", "content_002_access.mp4", "content_003_access.mp4"]
      fields[:format_dtl_display].should == [""]    
    end
    it "should return a list of additional fiels for an achival video" do
      fields = @d.addl_solr_fields("rrhof:331")
      fields[:access_file_s].should == ["39156042459763_access.mp4"]
      fields[:format_dtl_display].should == ["H.264/MPEG-4 AVC"]
    end
  end

end