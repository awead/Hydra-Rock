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

end