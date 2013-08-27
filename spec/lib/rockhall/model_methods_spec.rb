require "spec_helper"

describe Rockhall::ModelMethods do

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

end
