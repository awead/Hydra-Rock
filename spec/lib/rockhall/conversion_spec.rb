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
  	av.collection_number.should == ["RG.0004"]
  end

  it "should convert an old ExternalVideo to a new one" do


  end


	
end