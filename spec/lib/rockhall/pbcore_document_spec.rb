require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Rockhall::PbcoreDocument do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Rockhall::PbcoreDocument.new
  end

  describe ".new" do
    it "should initialize a new PBCore document template if no xml is provided" do
      article_ds = Rockhall::PbcoreDocument.new
      article_ds.ng_xml.to_xml.should == Rockhall::PbcoreDocument.xml_template.to_xml
    end
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        [:pbc_id],
        [:main_title],
        [:alternative_title],
        [:chapter],
        [:episode],
        [:label],
        [:segment],
        [:subtitle],
        [:track],
        [:translation],
        [:description],
        [:contents],
        [:subject],
        [:genre],
        [:series],
        [{:pbcore_coverage=>0}, :coverage], # until [:event_place] works
        [{:pbcore_coverage=>1}, :coverage], # until [:event_time] works
        [:contributor_name],
        [:contributor_role],
        [:publisher_name],
        [:publisher_role],
        [:note],
        [:creation_date],
        [:barcode],
        [:repository],
        [:format],
        [:standard],
        [:media_type],
        [:generation],
        [:colors],
        [:archival_collection],
        [:archival_series],
        [:collection_number],
        [:accession_number],
        [:usage],
        [:condition_note],
        [:cleaning_note]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should work for fields that require added xml nodes" do
      @object_ds.insert_node("pbcorePublisher")
      @object_ds.insert_node("pbcoreContributor")
      [
        [:publisher_name],
        [:publisher_role],
        [:contributor_name],
        [:contributor_role]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should differentiate between multiple added nodes" do
      @object_ds.insert_node(:pbcoreContributor)
      @object_ds.insert_node(:pbcoreContributor)
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 0 => "first contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 1 => "second contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 0 => "first contributor role" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 1 => "second contributor role" }} )
      @object_ds.get_values(:contributor_name).length.should == 2
      @object_ds.get_values(:contributor_name)[0].should == "first contributor"
      @object_ds.get_values(:contributor_name)[1].should == "second contributor"
      @object_ds.get_values(:contributor_role)[0].should == "first contributor role"
      @object_ds.get_values(:contributor_role)[1].should == "second contributor role"
    end

  end

  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do

      # insert additional nodes
      @object_ds.insert_node("pbcorePublisher")
      @object_ds.insert_node("pbcoreContributor")

      # update additional nodes that OM will insert automatically
      @object_ds.update_indexed_attributes({ [:alternative_title] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:chapter] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:episode] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:label] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:segment] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subtitle] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:track] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:translation] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:condition_note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:cleaning_note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:format] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:standard] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:usage] => { 0 => "inserted" }} )

      # Load example fixture
      f = File.open("#{Rails.root.to_s}/spec/fixtures/rockhall/pbcore_document_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document
      sample_node = Nokogiri::XML(@object_ds.to_xml)

      # Save this for later...
      out = File.new("tmp/pbcore_document_sample.xml", "w")
      out.write(sample_node.to_s)
      out.close

      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true

    end
  end

  describe ".insert_node" do
    it "should return a node and index for a given template type" do
      ["pbcorePublisher", "pbcoreContributor"].each do |type|
        node, index = @object_ds.insert_node(type.to_s)
        index.should == 0
        @object_ds.dirty?.should be_true
        node, index = @object_ds.insert_node(type.to_s)
        index.should == 1
      end
    end

    it "should raise an exception for non-exisitent templates" do
      lambda { @object_ds.insert_node("blarg") }.should raise_error
    end
  end

  describe ".remove_node" do
    it "should remove a node a given type and index" do
      ["pbcorePublisher", "pbcoreContributor"].each do |type|
        @object_ds.insert_node(type.to_sym)
        @object_ds.insert_node(type.to_sym)
        @object_ds.find_by_terms(type.to_sym).count.should == 2
        @object_ds.remove_node(type.to_sym, "1")
        @object_ds.find_by_terms(type.to_sym).count.should == 1
        @object_ds.remove_node(type.to_sym, "0")
        @object_ds.find_by_terms(type.to_sym).count.should == 0
      end
    end

    it "should add and remove existing nodes" do
      pending "No existing nodes needed to add"
      ["note"].each do |type|
        @object_ds.find_by_terms(type.to_sym).count.should == 1
        @object_ds.insert_node(type.to_sym)
        @object_ds.find_by_terms(type.to_sym).count.should == 2
        @object_ds.remove_node(type.to_sym, "1")
        @object_ds.find_by_terms(type.to_sym).count.should == 1
        @object_ds.remove_node(type.to_sym, "0")
        @object_ds.find_by_terms(type.to_sym).count.should == 0
      end
    end
  end

  describe "default fields" do

    it "such as media type should be 'Moving image'" do
      @object_ds.get_values([:media_type]).first.should == "Moving image"
    end

    it "such as colors should be 'Color'" do
      @object_ds.get_values([:colors]).first.should == "Color"
    end

    it "such as generation should be 'Original'" do
      @object_ds.get_values([:generation]).first.should == "Original"
    end

  end

end
