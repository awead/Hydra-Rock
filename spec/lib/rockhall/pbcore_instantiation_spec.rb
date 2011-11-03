require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Rockhall::PbcoreInstantiation do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Rockhall::PbcoreInstantiation.new
  end

  describe ".new" do
    it "should initialize a new PBCore instantiation template if no xml is provided" do
      article_ds = Rockhall::PbcoreInstantiation.new
      article_ds.ng_xml.to_xml.should == Rockhall::PbcoreInstantiation.xml_template.to_xml
    end
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        [:name],
        [:date],
        [:generation],
        [:generation, :ref],
        [:type],
        [:size],
        [:size, :units],
        [:rate],
        [:rate, :units],
        [:colors],
        [:colors, :ref],
        [:duration],
        [:link],
        [:rights_summary],
        [:rights_link],
        [:chksum_type],
        [:chksum_value],
        [:device],
        [:capture_soft],
        [:trans_soft],
        [:operator],
        [:trans_note],
        [:vendor],
        [:cond_note],
        [:clean_note],
        [:note]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end
  end

  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do
      f = File.open("#{Rails.root.to_s}/spec/fixtures/rockhall/pbcore_instantiation_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end



end
