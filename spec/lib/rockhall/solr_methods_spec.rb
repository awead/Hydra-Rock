require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"

describe Rockhall::SolrMethods do

  before(:each) do
    class SolrTest
      include Rockhall::SolrMethods
    end
    @solr = SolrTest.new
  end

  describe "a four-digit date" do

    it "should come from just four numbers" do
      @solr.get_year_from_date("2001").should == "2001"
    end

    it "should come from a complete date" do
      @solr.get_year_from_date("1998-03-04").should == "1998"
    end

    it "should be nil if the date is invalid" do
      @solr.get_year_from_date("2003-12").should be_nil
    end

  end

end
