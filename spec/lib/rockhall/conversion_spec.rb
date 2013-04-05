require "spec_helper"

describe Rockhall::Conversion do

  it "should convert an old ArchivalVideo to a new one" do
  	av = ArchivalVideo.find("rrhof:331")
  	ev = av.from_archival_video
  	ev.generation.should        == ["Original"]
  	ev.barcode.should           == ["39156042459763"]
  	av.event_date.should        == ["2001-05-03"]
  	av.event_place.should       == ["Rock and Roll Hall of Fame and Museum, Cleveland, Ohio"]
  	av.event_series.should      == ["Evening with series (Rock and Roll Hall of Fame and Museum)"]
  	av.collection_number.should == "RG.0004"
  end

  describe ".from_external_video" do
    it "should convert an old ExternalVideo to a new one" do
      ev = ExternalVideo.find("rrhof:506")
      ev.datastreams["descMetadata"].ng_xml.xpath("//pbcoreDescriptionDocument").should_not be_empty
      ev.from_external_video
      ev.generation.should == ["Copy: access"]
      ev.name.should       == ["39156042459763_access.mp4"] 
      ev.datastreams["descMetadata"].ng_xml.xpath("//pbcoreDescriptionDocument").should be_empty
    end

    it "should not convert anything else" do
      av = ArchivalVideo.new nil
      lambda { av.from_external_video }.should raise_error
    end
  end

  describe ".from_digital_video" do
  	it "should convert an old DigitalVideo into an ArchivalVideo" do
  	  dv = DigitalVideo.find("rockhall:fixture_pbcore_digital_document1")
  	  av = dv.from_digital_video
  	  av.pid.should == "rockhall:fixture_pbcore_digital_document1"
  	  av.videos.should == dv.videos
  	end

  	it "should not convert anything else" do
  	  av = ArchivalVideo.new nil
  	  lambda { av.from_digital_video }.should raise_error
  	end
  end
	
end