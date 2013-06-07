require 'spec_helper'

describe Rockhall::Headings do

  before :each do

    class HeadingTest
      include Rockhall::Headings
    end
    @test = HeadingTest.new

  end

  describe ".suggested_facets_from_solr" do

    describe "from a given query" do

      it "should return subject headings" do
        result = @test.suggested_facets_from_solr("subject_facet", "Rock")
        result.should include("Rock music--History and criticism")
        result.should_not include(0)
      end

      it "should return genre headings" do
        result = @test.suggested_facets_from_solr("genre_facet", "Rock")
        result.should include("Rock concert films.")
        result.should_not include(0)
      end

      it "should return name headings" do
        result = @test.suggested_facets_from_solr("contributor_name_facet", "Hun")
        result.should include("Hunter, Ian, 1939-")
        result.should_not include(0)
      end

    end

    describe "with empty results" do
      it "should return no subject headings" do
        result = @test.suggested_facets_from_solr("subject_facet", "dasfg")
        result.should be_empty
      end
      it "should return no genre headings" do
        result = @test.suggested_facets_from_solr("genre_facet", "dasfg")
        result.should be_empty
      end
    end
  end

  describe "lcsh_suggestions" do
    it "should return an array of suggestions from LOC" do
      result = @test.lcsh_suggestions("ABBA")
      result.should include("ABBA (Musical group)")
    end

    it "should return empty" do
      result = @test.lcsh_suggestions("asdfs")
      result.should be_empty
    end

    it "should return properly encoded strings" do
      result = @test.lcsh_suggestions("Hun")
      result.first.encoding.name.should == "UTF-8"
    end
  end

  describe "named headings" do
    it "should include subjects" do
      @test.subjects("Rock").should_not be_nil
      @test.subjects.should be_empty
    end

    it "should include genres" do
      @test.genres("Rock").should_not be_nil
      @test.genres.should be_empty
    end

    it "should include names" do
      @test.names("Hun").should_not be_nil
      @test.names.should be_empty
    end

  end

end