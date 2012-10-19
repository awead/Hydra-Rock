require "spec_helper"

describe Rockhall::IndexMethods do

  before :all do
    av    = ArchivalVideo.find("rockhall:fixture_pbcore_document1")
    @ds   = av.datastreams["descMetadata"]
  end

  it "should format the contributors_display field" do
    @ds.format_contributors_display.first.should == "Springsteen, Bruce (recipient)"
  end


end
