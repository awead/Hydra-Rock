require "spec_helper"

describe Rockhall::Models do

  describe ".transfer_videos_from_pid" do

    # setup the scenario with two videos, each with a tape
    before :all do
      @video1 = ArchivalVideo.new
      @video1.title = "Video1"
      @video1.save
      @video2 = ArchivalVideo.new
      @video2.title = "Video2"
      @video2.save

      @tape1 = ExternalVideo.new
      @tape1.define_physical_instantiation
      @tape1.barcode = "1"
      @tape1.save
      @tape2 = ExternalVideo.new
      @tape2.define_physical_instantiation
      @tape2.barcode = "2"
      @tape2.save

      @video1.external_videos << @tape1
      @tape1.save
      @video1.save

      @video2.external_videos << @tape2
      @tape2.save
      @video2.save
    end

    describe "should move all the instantiations from one video object to another" do
      it "should move the tape instantiations" do
        @video1.videos[:original].first.should == @tape1
        @video2.videos[:original].first.should == @tape2
        @video1.transfer_videos_from_pid @video2.pid
        @video1.reload; @video2.reload; @tape1.reload; @tape2.reload
        @tape1.parent.should == @video1
        new_tape2 = ExternalVideo.find(@tape2.pid)
        new_tape2.parent.should == @video1
        @video1.external_videos.count.should == 2
        @video2.external_videos.count.should == 0
      end

    end

    describe "with errors" do

      it "should return false for non-existent objects" do
        sample = ArchivalVideo.new
        sample.transfer_videos_from_pid("foo").should be_false
        sample.errors.messages[:transfer_videos_from_pid].should == ["Source foo does not exist"]
      end

      it "should return false for objects that have no external videos" do
        sample = ArchivalVideo.new
        sample.transfer_videos_from_pid("rockhall:fixture_pbcore_document4").should be_false
        sample.errors.messages[:transfer_videos_from_pid].should == ["Source rockhall:fixture_pbcore_document4 has no videos"]
      end

    end

  end

  describe ".to_pbcore_xml" do

    it "should return a complete, valid pbcore document" do
      ArchivalVideo.find("rrhof:331").valid_pbcore?.should be_true
    end

  end

  describe "#update_collection" do

    before :each do
      @sample = ArchivalVideo.new
    end

    after :each do
      @sample.valid_pbcore?.should be_true
    end

    it "adds a new collection" do
      args = {:collection => "ARC-0001", :archival_series => ""}
      @sample.update_collection args
      @sample.collection.should == "Art Collins Papers"
      @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0001"
      @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
    end

    it "adds a new collection and series" do
      args = {:collection => "ARC-0001", :archival_series => "ref2619"}
      @sample.update_collection args
      @sample.collection.should == "Art Collins Papers"
      @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0001"
      @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
      @sample.archival_series.should == "Subseries 4: Miscellaneous Formats [RESTRICTED]"
      @sample.archival_series_uri.should == "http://repository.rockhall.org/collections/ARC-0001/components/ref2619"
      @sample.archival_series_authority.should == "Rock and Roll Hall of Fame and Museum"
    end

    describe "with an existing collection" do

      before :each do
        args = {:collection => "ARC-0001", :archival_series => ""}
        @sample.update_collection args
      end

      it "should remove the collection" do
        args = {:collection => "", :archival_series => ""}
        @sample.update_collection args
        @sample.collection.should be_nil
        @sample.collection_uri.should be_nil
        @sample.collection_authority.should be_nil
      end

      it "should update the collection" do
        args = {:collection => "ARC-0002", :archival_series => ""}
        @sample.update_collection args
        @sample.collection.should == "Sire Records Collection"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0002"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
      end

      it "should update the series using the same collection" do
        args = {:collection => "ARC-0001", :archival_series => "ref2619"}
        @sample.update_collection args
        @sample.collection.should == "Art Collins Papers"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0001"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
        @sample.archival_series.should == "Subseries 4: Miscellaneous Formats [RESTRICTED]"
        @sample.archival_series_uri.should == "http://repository.rockhall.org/collections/ARC-0001/components/ref2619"
        @sample.archival_series_authority.should == "Rock and Roll Hall of Fame and Museum"
      end

      it "should update the series and collection" do
        args = {:collection => "ARC-0002", :archival_series => "ref557"}
        @sample.update_collection args
        @sample.collection.should == "Sire Records Collection"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0002"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
        @sample.archival_series.should == "Subseries 2: Financial Files"
        @sample.archival_series_uri.should == "http://repository.rockhall.org/collections/ARC-0002/components/ref557"
        @sample.archival_series_authority.should == "Rock and Roll Hall of Fame and Museum"
      end

    end

    describe "with an existing collection and series" do

      before :each do
        args = {:collection => "ARC-0001", :archival_series => "ref2619"}
        @sample.update_collection args
      end

      it "deletes series, but not collection" do
        args = {:collection => "ARC-0001", :archival_series => ""}
        @sample.update_collection args
        @sample.collection.should == "Art Collins Papers"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0001"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
        @sample.archival_series.should be_nil
        @sample.archival_series_uri.should be_nil
        @sample.archival_series_authority.should be_nil
      end

      it "deletes both series and collection" do
        args = {:collection => "", :archival_series => ""}
        @sample.update_collection args
        @sample.collection.should be_nil
        @sample.collection_uri.should be_nil
        @sample.collection_authority.should be_nil
        @sample.archival_series.should be_nil
        @sample.archival_series_uri.should be_nil
        @sample.archival_series_authority.should be_nil
      end

      it "updates both series and collection" do
        args = {:collection => "ARC-0002", :archival_series => "ref557"}
        @sample.update_collection args
        @sample.collection.should == "Sire Records Collection"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0002"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
        @sample.archival_series.should == "Subseries 2: Financial Files"
        @sample.archival_series_uri.should == "http://repository.rockhall.org/collections/ARC-0002/components/ref557"
        @sample.archival_series_authority.should == "Rock and Roll Hall of Fame and Museum"
      end

      it "updates collection and deletes series" do
        args = {:collection => "ARC-0002", :archival_series => ""}
        @sample.update_collection args
        @sample.collection.should == "Sire Records Collection"
        @sample.collection_uri.should == "http://repository.rockhall.org/collections/ARC-0002"
        @sample.collection_authority.should == "Rock and Roll Hall of Fame and Museum"
        @sample.archival_series.should be_nil
        @sample.archival_series_uri.should be_nil
        @sample.archival_series_authority.should be_nil
      end

    end

  end

end
