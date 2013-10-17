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

  it "should create a session with a default url" do
    @d.solr.uri.to_s.should match(RH_CONFIG["solr_discovery"])
  end

  it "should create a session with a given url" do
    s = Rockhall::Discovery.new "foo"
    s.solr.uri.to_s.should match(/foo/)
  end

  it "should create a connection to our Blacklight solr index" do
    @d.solr.should be_a_kind_of(RSolr::Client)
  end

  describe "#exports" do
    it "should be an array of AF objects that can be exported to Blacklight" do
      @d.exports.should be_a_kind_of(Array)
      @d.exports.count.should == 4
    end
  end

  describe "#blacklight_items" do
    it "should be an array of the existing Hydra objects in Blacklight's solr index" do
      @d.blacklight_items.length.should == 4
    end

    it "should be indexed according to the catalog's schema" do
      params = {:q => 'id:"rrhof:331"', :qt => 'document'}
      doc = @d.solr.get("select", :params=>params)["response"]["docs"].first
      doc["title_display"].should == "Evening with series. Ian Hunter. Part 2."
      doc["collection_facet"].should == ["Rock and Roll Hall of Fame and Museum Records"]
      doc["subject_display"].should include("Rock musicians--England")
      doc["subject_facet"].should include("Rock musicians")
      doc["subject_facet"].should include("England")
      doc["series_display"].should == ["Evening with series (Rock and Roll Hall of Fame and Museum)"]
      doc["genre_facet"].should include("Filmed performances")
    end

  end

end