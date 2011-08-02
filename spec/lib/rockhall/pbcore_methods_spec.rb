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

  describe "#contributor_template" do
    it "should insert a contributor xml template" do
      xml = '
        <pbcoreContributor>
          <contributor/>
          <contributorRole source="MARC List for Relators" ref=""/>
        </pbcoreContributor>
      '
      node = MethodTest.contributor_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#publisher_template" do
    it "should insert a publisher xml template" do
      xml = '
        <pbcorePublisher>
          <publisher/>
          <publisherRole source="PBcore publisherRole" ref=""/>
        </pbcorePublisher>
      '
      node = MethodTest.publisher_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#topic_template" do
    it "should insert a topic xml template" do
      xml = '<pbcoreSubject subjectType="topic" source="Library of Congress Subject Headings" ref=""/>'
      node = MethodTest.topic_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#era_template" do
    it "should insert a topic xml template" do
      xml = '<pbcoreSubject subjectType="era" source="Library of Congress Subject Headings"/>'
      node = MethodTest.era_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#place_template" do
    it "should insert a topic xml template" do
      xml = '<pbcoreSubject subjectType="place" source="Library of Congress Subject Headings"/>'
      node = MethodTest.place_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

   describe "#event_template" do
    it "should insert a topic xml template" do
      xml = '<pbcoreSubject subjectType="event" source="Library of Congress Subject Headings"/>'
      node = MethodTest.event_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#entity_template" do
    it "should insert a topic xml template" do
      xml = '<pbcoreSubject subjectType="entity" source="Library of Congress Name Authorities"/>'
      node = MethodTest.entity_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#genre_template" do
    it "should insert a genre xml template" do
      xml = '<pbcoreGenre source="Library of Congress Subject Headings" ref=""/>'
      node = MethodTest.genre_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#series_template" do
    it "should insert a series xml template" do
      xml = '
        <pbcoreRelation>
          <pbcoreRelationType source="PBCore relationType" ref="http://pbcore.org/vocabularies/relationType#is-part-of">
            Is Part Of
          </pbcoreRelationType>
          <pbcoreRelationIdentifier/>
        </pbcoreRelation>
      '
      node = MethodTest.series_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#note_template" do
    it "should insert a node node with the right attribute" do
      xml = '<pbcoreAnnotation annotationType="note"/>'
      node = MethodTest.note_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#alt_title_template" do
    it "should insert an alternative title" do
      xml = '<pbcoreTitle titleType="Alternatitve" annotation="Other Title"/>'
      node = MethodTest.alt_title_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#episode_template" do
    it "should insert an episode title" do
      xml = '<pbcoreTitle titleType="Episode"/>'
      node = MethodTest.episode_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#sub_title_template" do
    it "should insert a subtitle" do
      xml = '<pbcoreTitle titleType="Subtitle"/>'
      node = MethodTest.sub_title_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "#caption_template" do
    it "should insert a closed captioning field" do
      xml = '<instantiationAlternativeModes/>'
      node = MethodTest.caption_template
      EquivalentXml.equivalent?(xml, node.to_xml, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end
end