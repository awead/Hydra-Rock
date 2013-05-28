require "spec_helper"

describe Rockhall::Conversion do

  # Load fixtures specific to conversion
  before :all do
    @pid_list = Array.new
    contents = Dir.glob("spec/fixtures/convert/*.xml")
    contents.each do |file|
      pid = ActiveFedora::FixtureLoader.import_to_fedora(file)
      ActiveFedora::FixtureLoader.index(pid)
      @pid_list << pid
    end
  end

  # Delete the fixtures we loaded for these tests
  after :all do
    @pid_list.each do |pid|
      ActiveFedora::Base.find(pid, :cast=>true).delete
    end
  end

  it "should convert an old ArchivalVideo to a new one" do
  	av = ArchivalVideo.find("rrhof:1041")
  	ev = av.from_archival_video
  	ev.generation.should            == ["Original"]
  	ev.barcode.should               == ["39156042459326"]
  	av.event_date.should            == ["2001-02-01"]
  	av.event_place.should           == ["Rock and Roll Hall of Fame and Museum, Cleveland, Ohio"]
  	av.event_series.should          == ["Evening with series (Rock and Roll Hall of Fame and Museum)"]
    av.additional_collection.should == ["Rock and Roll Hall of Fame and Museum records. Education and Public Programs Division"]
  	av.collection_number.should     == "RG.0004"
  end

  describe ".from_external_video" do
    it "should convert an old ExternalVideo to a new one" do
      ev = ExternalVideo.find("rrhof:2406")
      ev.datastreams["descMetadata"].ng_xml.xpath("//pbcoreDescriptionDocument").should_not be_empty
      ev.from_external_video
      ev.generation.should == ["Copy: access"]
      ev.name.should       == ["rrhof_2405_001_access.mp4"] 
      ev.datastreams["descMetadata"].ng_xml.xpath("//pbcoreDescriptionDocument").should be_empty
    end

    it "should not convert anything else" do
      av = ArchivalVideo.new nil
      lambda { av.from_external_video }.should raise_error
    end
  end

  describe ".from_digital_video" do
  	it "should convert an old DigitalVideo into an ArchivalVideo" do
  	  dv = DigitalVideo.find("rrhof:2405")
  	  av = dv.from_digital_video
  	  av.pid.should                   == "rrhof:2405"
  	  av.title.should                 == "Oral History project. Clive Davis."
      av.event_series.should          == ["Oral history project (Rock and Roll Hall of Fame and Museum)"]
      av.event_date.should            == ["2011-12-10"]
      av.event_place.should           == ["Pound Ridge, New York"]
      av.accession_number.should      == ["LA.2012.05.024"]
      av.additional_collection.should == ["Rock and Roll Hall of Fame and Museum records. Education and Public Programs Division."]
      av.collection_number.should     == "RG.0004"
      av.archival_series.should       == "Oral history project"
    end

  	it "should not convert anything else" do
  	  av = ArchivalVideo.new nil
  	  lambda { av.from_digital_video }.should raise_error
  	end
  end

  describe "ArchivalVideo models without instantiations" do

    it "should convert to new ArchivalVideo models without attached ExternalVideos" do
      av = ArchivalVideo.find("rrhof:2166")
      ev = av.from_archival_video
      ev.should be_nil
      av.title.should == "Black history month. Gloria Jones"
      av.alternative_title.should == ["Gloria Jones"]
      av.external_videos.should be_empty
    end

  end
	
end