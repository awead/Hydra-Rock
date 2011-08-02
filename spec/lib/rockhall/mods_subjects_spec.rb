require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"

describe Rockhall::ModsSubjects do

  before(:all) do
    class ContributorTest < ActiveFedora::NokogiriDatastream
      include Rockhall::ModsSubjects
    end
  end

  describe "subject_nodes" do
    it "should generate a new personal subject node" do
      node = ContributorTest.subject_template(:personal)
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<subject authority=\"lcsh\">\n  <name type=\"personal\">\n    <namePart type=\"given\"/>\n    <namePart type=\"family\"/>\n    <namePart type=\"date\"/>\n    <namePart type=\"termsOfAddress\"/>\n  </name>\n</subject>"   
    end
    
    it "should generate a new subject node for corporate and conference" do
      ["conference", "corporate"].each do |name|
        node = ContributorTest.subject_template(name)
        node.should be_kind_of(Nokogiri::XML::Element)
        node.to_xml.should == "<subject authority=\"lcsh\">\n  <name type=\"#{name}\">\n    <namePart/>\n  </name>\n</subject>"
      end
    end
  end
  
  describe "title subject node" do
    it "should generate a new title_info subject node" do
      node = ContributorTest.subject_template("title_info")
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<subject authority=\"lcsh\">\n  <titleInfo>\n    <title/>\n    <subTitle/>\n    <partNumber/>\n    <partName/>\n  </titleInfo>\n</subject>"
    end
  end
  
  describe "topic subject node" do
    it "should generate a new topic subject node" do
      node = ContributorTest.subject_template("topic")
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<subject authority=\"lcsh\">\n  <topic/>\n  <temporal/>\n  <genre/>\n</subject>"
    end
  end
  
  describe "geographic subject node" do
    it "should generate a new geographic subject node" do
      node = ContributorTest.subject_template("geographic")
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<subject authority=\"lcsh\">\n  <geographic/>\n</subject>"
    end
  end       
  
end
  
