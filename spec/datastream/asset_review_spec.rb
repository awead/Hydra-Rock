require "spec_helper"

describe AssetReview do

  before(:each) do
    @av = ArchivalVideo.new nil
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        "reviewer",
        "date_updated",
        "complete",
        "abstract",
        "license",
        "priority",
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @av.send("#{pointer}=".to_sym, test_val)
        @av.send(pointer).first.should == test_val
        @av.send(pointer).length.should == 1
      end
    end
  end

  describe "#xml_template" do
    it "should return an empty xml document matching a valid exmplar" do
      ref_node = Nokogiri::XML(fixture "asset_review_template.xml")
      sample_node = Nokogiri::XML(@av.datastreams["assetReview"].to_xml)
      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end

    it "should have fields defaulted to certain values" do
      @av.complete.first.should == "no"
      @av.priority.first.should == "normal"
    end
  end

end