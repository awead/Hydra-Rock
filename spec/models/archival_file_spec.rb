require 'spec_helper'

describe ArchivalFile do

  before :each do
    @file = ArchivalFile.new
  end

  after :each do
    #@file.delete
  end

  it "should have depositor metadata" do
    @file.apply_depositor_metadata "mrfoo@rockhall.org"
    @file.depositor.should == "mrfoo@rockhall.org"
  end

  it "should have a pbcore descriptive metadata" do
    @file.title = "My Title"
    @file.descMetadata.to_solr["title_ssm"].should == ["My Title"] 
  end

  it "should have an ArchivalFileRdfDatastream for descMetadata" do
    @file.descMetadata.should be_kind_of ArchivalFileRdfDatastream
  end



end