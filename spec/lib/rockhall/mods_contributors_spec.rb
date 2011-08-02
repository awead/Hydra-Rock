require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"

describe Rockhall::ModsContributors do

  before(:all) do
    class ContributorTest < ActiveFedora::NokogiriDatastream
      include Rockhall::ModsContributors
    end
  end
  
  before(:each) do
    #Fedora::Repository.stubs(:instance).returns(stub_everything())
    @contributor = ContributorTest.new
  end  
  
  describe "#person_template" do
    it "should generate a new individual node" do
      node = ContributorTest.person_template
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<name type=\"personal\" authority=\"naf\">\n  <namePart type=\"family\"/>\n  <namePart type=\"given\"/>\n  <namePart type=\"date\"/>\n  <namePart type=\"termsOfAddress\"/>\n  <role>\n    <roleTerm type=\"text\"/>\n  </role>\n</name>"
    end
  end

  describe "#corporate_template" do
    it "should generate a new corporate node" do
      node = ContributorTest.corporate_template
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<name type=\"corporate\" authority=\"naf\">\n  <namePart/>\n  <role>\n    <roleTerm type=\"text\"/>\n  </role>\n</name>"
    end
  end
  
  describe "#conference_template" do
    it "should generate a new conference node" do
      node = ContributorTest.conference_template
      node.should be_kind_of(Nokogiri::XML::Element)
      node.to_xml.should == "<name type=\"conference\" authority=\"naf\">\n  <namePart/>\n  <role>\n    <roleTerm type=\"text\"/>\n  </role>\n</name>"
    end
  end
  
end
