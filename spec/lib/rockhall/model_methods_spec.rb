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
        @video1.transfer_videos_from @video2
        @tape1.parent.should == @video1
        @tape2.parent.should == @video1
        @video1.reload
        @video1.external_videos.count.should == 2
        @video2.external_videos.count.should == 0
      end

    end

    describe "with errors" do

      it "should return false for objects with no external videos" do
        source = ArchivalVideo.new(:pid => "foo")
        @video1.transfer_videos_from(source).should be_false
        #source = ArchivalVideo.new nil
        #test = ArchivalVideo.new nil
        #test.transfer_videos_from(source).should be_nil
      end


    end

  end

  describe ".to_pbcore_xml" do

    it "should return a complete, valid pbcore document" do
      ArchivalVideo.find("rrhof:331").valid_pbcore?.should be_true     
    end

  end

  describe ".update_metadata" do

    before :each do
      @video = ArchivalVideo.new nil
      @video.title = "Testing Rockhall::ModelMethods.update_metadata"
      @video.alternative_title = ["one", "two", "three"]
      @video.segment = "a segment"
    end

    it "should replace all existing terms with a given array of new terms" do
      terms = {:alternative_title => ["four","five"]}
      @video.alternative_title.should == ["one", "two", "three"]
      @video.update_metadata(terms).should == "nodes removed"
      @video.alternative_title.should == ["four", "five"]
      @video.segment.should == ["a segment"]
    end

    it "should update terms with the same number of values" do
      terms = {:alternative_title => ["1", "2", "3"]}
      @video.alternative_title.should == ["one", "two", "three"]
      @video.update_metadata(terms).should be_nil
      @video.alternative_title.should == ["1", "2", "3"]
      @video.segment.should == ["a segment"]
    end

    it "should update terms that have no values with new, multiple values" do
      terms = {:chapter => ["one", "two", "three"]}
      @video.chapter.should be_empty
      @video.update_metadata(terms).should be_nil
      @video.chapter.should == ["one", "two", "three"]
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["a segment"]
    end

    it "should update existing single-valued terms" do
      terms = {:segment => "another segment"}
      @video.segment.should == ["a segment"]
      @video.update_metadata(terms).should be_nil
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["another segment"]
    end

    it "should update existing single-valued arrays" do
      terms = {:segment => ["another segment"]}
      @video.segment.should == ["a segment"]
      @video.update_metadata(terms).should be_nil
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["another segment"]
    end

    it "should update terms that have no values with single values" do
      terms = {:chapter => "one"}
      @video.chapter.should be_empty
      @video.update_metadata(terms).should be_nil
      @video.chapter.should == ["one"]
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["a segment"]
    end

    it "should update terms that have no values with single-valued arrays" do
      terms = {:chapter => ["one"]}
      @video.chapter.should be_empty
      @video.update_metadata(terms).should be_nil
      @video.chapter.should == ["one"]
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["a segment"]
    end

    it "should update terms that are unique" do
      terms = {:title => "sample title"}
      @video.update_metadata(terms).should be_nil
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["a segment"]
      @video.title.should == "sample title"
    end

    it "should update existing title terms" do
      terms = {:title => "sample title"}
      @video.title = "existing title"
      @video.update_metadata(terms).should be_nil
      @video.alternative_title.should == ["one", "two", "three"]
      @video.segment.should == ["a segment"]
      @video.title.should == "sample title"
    end

  end

end
