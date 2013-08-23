require "spec_helper"

describe ExternalVideo do

  before(:each) do
    @video = ExternalVideo.new nil
    @video.define_physical_instantiation
    @video.stubs(:create_date).returns("2008-07-02T05:09:42.015Z")
    @video.stubs(:modified_date).returns("2008-09-29T21:21:52.892Z")
  end

  it "Should be a kind of ActiveFedora::Base" do
    @video.should be_kind_of(ActiveFedora::Base)
  end

  describe '#garbage_collect' do
    it "should delete the object if it does not have any objects asserting has_collection_member" do
      mock_non_orphan = mock("non-orphan file asset", :containers=>["foo"])
      mock_non_orphan.expects(:delete).never

      mock_orphan = mock("orphan file asset", :containers=>[])
      mock_orphan.expects(:delete)

      ExternalVideo.expects(:find).with("_non_orphan_pid_").returns(mock_non_orphan)
      ExternalVideo.expects(:find).with("_orphan_pid_").returns(mock_orphan)

      ExternalVideo.garbage_collect("_non_orphan_pid_")
      ExternalVideo.garbage_collect("_orphan_pid_")
    end
  end

  describe "file order" do
    it "should have a next file" do
      @video.insert_next("foo.mp4")
      @video.next.should == ["foo.mp4"]
    end

    it "should have a previous file" do
      @video.insert_previous("foo.mp4")
      @video.previous.should == ["foo.mp4"]
    end
  end

  describe "relationships" do

    before :all do
      @parent = ArchivalVideo.new
      @parent.title = "Parent"
      @parent.save
      @child = ExternalVideo.new
      @child.save
      @parent.external_videos << @child
      @parent.save
      @child.save
    end

    after :all do
      @parent.delete
      @child.delete
    end

    it "should be parent to child" do
      @child.parent.title.should == "Parent"
    end

    it "should have a single parent video" do
      ev = ExternalVideo.find("rockhall:fixture_pbcore_document5_h2642")
      ev.parent.should be_kind_of(ArchivalVideo)
    end
  end

  describe "delegate fields" do
    before :all do
      @delegate = ExternalVideo.find("rockhall:fixture_pbcore_document5_h2641")
    end
    it "should be defined" do
      @delegate.mi_file_format.first.should == "MPEG-4"
    end
  end

  describe ".path" do
    it "should return the full path to the file" do
      video = ExternalVideo.find("rockhall:fixture_pbcore_document3_h264")
      video.path.should == File.join(RH_CONFIG["location"], "rockhall:fixture_pbcore_document3", "data", "39156042439369_access.mp4")
    end

    it "should return nil for videos that have no parent" do
      @video.path.should be_nil
    end


  end

end