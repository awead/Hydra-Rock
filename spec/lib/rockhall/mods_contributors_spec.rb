require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "equivalent-xml"

describe Rockhall::ModsContributors do

  before(:all) do
    class ContributorTest < ActiveFedora::NokogiriDatastream
      include Rockhall::ModsContributors
    end
  end

  before(:each) do
    @contributor = ContributorTest.new nil, nil
  end

  describe "#person_template" do
    it "should generate a new individual node" do
      node = ContributorTest.person_template
      node.should be_kind_of(Nokogiri::XML::Element)
      sample = "<name type=\"personal\" authority=\"naf\">  <namePart type=\"family\"/>  <namePart type=\"given\"/>  <namePart type=\"date\"/>  <namePart type=\"termsOfAddress\"/>  <role>    <roleTerm type=\"text\"/>  </role></name>"
      sample_node = Nokogiri::XML(sample)
      EquivalentXml.equivalent?(node.to_xml, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#corporate_template" do
    it "should generate a new corporate node" do
      node = ContributorTest.corporate_template
      node.should be_kind_of(Nokogiri::XML::Element)
      sample = "<name type=\"corporate\" authority=\"naf\">\n  <namePart/>\n  <role>\n    <roleTerm type=\"text\"/>\n  </role>\n</name>"
      sample_node = Nokogiri::XML(sample)
      EquivalentXml.equivalent?(node.to_xml, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#conference_template" do
    it "should generate a new conference node" do
      node = ContributorTest.conference_template
      node.should be_kind_of(Nokogiri::XML::Element)
      sample = "<name type=\"conference\" authority=\"naf\">\n  <namePart/>\n  <role>\n    <roleTerm type=\"text\"/>\n  </role>\n</name>"
      sample_node = Nokogiri::XML(sample)
      EquivalentXml.equivalent?(node.to_xml, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

end
