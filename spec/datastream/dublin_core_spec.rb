require "spec_helper"

describe DublinCore do

  before :each do
    @coll = ArchivalCollection.new nil
  end

  it "should have a title and xml" do
    @coll.title.should be_nil
    @coll.title = "My Collection"
    @coll.title.should == "My Collection"
    @coll.datastreams["descMetadata"].to_xml.should match "<dc:title>My Collection</dc:title>"
  end

end