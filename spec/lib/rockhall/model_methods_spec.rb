require "spec_helper"

describe Rockhall::ModelMethods do

  describe ".transfer_videos_from" do

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
        @video1.videos[:tape].first.should == @tape1
        @video2.videos[:tape].first.should == @tape2
        @video1.transfer_videos_from(@video2).should == @video2
        @tape1.parent.should == @video1
        @tape2.parent.should == @video1
        @video1.reload
        @video1.external_videos.count.should == 2
        @video2.external_videos.count.should == 0
      end

      it "should return nil if the source doesn't have any" do
        source = ArchivalVideo.new nil
        test = ArchivalVideo.new nil
        test.transfer_videos_from(source).should be_nil
      end

    end

  end

  describe ".to_pbcore_xml" do

    it "should return a complete, valid pbcore document" do
      ArchivalVideo.find("rrhof:331").valid_pbcore?.should be_true     
    end

  end

end
