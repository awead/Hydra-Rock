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

        [:full_title],
        [:sub_title],
        [:alt_title],
        [:episode],
        [:language],
        [:language, :ref],
        [:caption],
        [:summary],
        [:coverage, :event],
        [:coverage, :date],
        [:contents],
        [:note],
        [:entity],
        [:era],
        [:event],
        [:place],
        [:item, :media_type],
        [:item, :generation],
        [:item, :carrier],
        [:item, :standard],
        [:item, :barcode],
        [:item, :relation, :collection_name],
        [:item, :relation, :collection_number],
        [:item, :relation, :accession_number],
        [:item, :location],
        [:item, :note]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should work for fields that require added xml nodes" do
      @object_ds.insert_node("publisher")
      @object_ds.insert_node("contributor")
      @object_ds.insert_node("topic")
      @object_ds.insert_node("genre")
      @object_ds.insert_node("series")
      @object_ds.insert_node("event")
      @object_ds.insert_node("era")
      @object_ds.insert_node("place")
      @object_ds.insert_node("entity")
      @object_ds.insert_node("episode")
      @object_ds.insert_node("sub_title")
      @object_ds.insert_node("alt_title")
      @object_ds.insert_node("caption")
      [
        [:publisher, :name],
        [:publisher, :role],
        [:publisher, :role, :ref],
        [:contributor, :name],
        [:contributor, :role],
        [:contributor, :role, :ref],
        [:topic],
        [:topic, :ref],
        [:genre],
        [:genre, :ref],
        [:series, :name],
        [:event],
        [:era],
        [:place],
        [:entity],
        [:episode],
        [:alt_title],
        [:sub_title],
        [:caption]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should differentiate between multiple added nodes" do

      ["publisher","series"].each do |node|
        @object_ds.insert_node(node.to_sym)
        @object_ds.insert_node(node.to_sym)
        @object_ds.update_indexed_attributes( [{node.to_sym => 0}, :name] => "first" )
        @object_ds.update_indexed_attributes( [{node.to_sym => 1}, :name] => "second" )
        @object_ds.get_values(node.to_sym).length.should == 2
        @object_ds.get_values( [{node.to_sym => 0}, :name] ).first.should == "first"
        @object_ds.get_values( [{node.to_sym => 1}, :name] ).first.should == "second"
      end

    end

  end

  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do

      # insert additional templates
      @object_ds.insert_node("publisher")
      @object_ds.insert_node("contributor")
      @object_ds.insert_node("topic")
      @object_ds.insert_node("genre")
      @object_ds.insert_node("series")
      @object_ds.insert_node("event")
      @object_ds.insert_node("era")
      @object_ds.insert_node("place")
      @object_ds.insert_node("entity")
      @object_ds.insert_node("episode")
      @object_ds.insert_node("sub_title")
      @object_ds.insert_node("alt_title")
      @object_ds.insert_node("caption")

      # Load example fixture
      f = File.open("#{Rails.root.to_s}/spec/fixtures/rockhall/pbcore_document_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document
      sample_node = Nokogiri::XML(@object_ds.to_xml)

      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true

    end
  end

  describe ".insert_node" do
    it "should return a node and index for a given template type" do
      ["publisher", "contributor","genre","topic","series","event","era","place","entity","episode","sub_title","alt_title","caption"].each do |type|
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
      ["publisher", "contributor","genre","topic","event","era","place","entity","episode","sub_title","alt_title","caption","series"].each do |type|
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

end
