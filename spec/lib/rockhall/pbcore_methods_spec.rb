require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Rockhall::PbcoreMethods do

  before(:all) do
    class MethodTest < ActiveFedora::NokogiriDatastream
      include Rockhall::PbcoreMethods
    end
  end

  describe "#pbcoreContributor_template" do
    it "should insert a contributor xml template" do
      xml = '
        <pbcoreContributor>
          <contributor/>
          <contributorRole source="MARC relator terms"/>
        </pbcoreContributor>
      '
      node = MethodTest.pbcoreContributor_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#pbcorePublisher_template" do
    it "should insert a publisher xml template" do
      xml = '
        <pbcorePublisher>
          <publisher/>
          <publisherRole source="PBCore publisherRole"/>
        </pbcorePublisher>
      '
      node = MethodTest.pbcorePublisher_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

end