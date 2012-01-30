require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "equivalent-xml"

describe Rockhall::AssetReview do

  before(:each) do
    av = ArchivalVideo.new nil
    @object_ds = av.datastreams["assetReview"]
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        [:reviewer],
        [:date_updated],
        [:complete],
        [:abstract],
        [:license]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_values( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end
  end

  describe "#xml_template" do
    it "should return an empty xml document matching a valid exmplar" do
      f = File.open("#{Rails.root.to_s}/spec/fixtures/rockhall/asset_review_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

end