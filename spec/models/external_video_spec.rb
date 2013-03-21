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

  it "should include Hydra Model Methods" do
    @video.class.included_modules.should include(Hydra::ModelMethods)
    @video.should respond_to(:apply_depositor_metadata)
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

  describe ".to_solr" do
    it "should allow for 4-digit date" do
      pending "Will pass when run separately, probably due to HydraPbcore::Mapper issues"
      @video.date = "1999"
      @video.to_solr["date_display"].should == ["1999"]
      @video.to_solr["date_dt"].should == ["1999-01-01T00:00:00Z"]
    end
    it "should use an incomplete date" do
      pending "Will pass when run separately, probably due to HydraPbcore::Mapper issues"
      @video.date = "2001-12"
      @video.to_solr["date_display"].should == ["2001-12"]
      @video.to_solr["date_dt"].should == ["2001-12-01T00:00:00Z"]
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
    it "should create archival video objects" do
      parent = ArchivalVideo.new
      parent.title = "Parent"
      parent.save
      child = ExternalVideo.new
      child.save
      parent.external_videos << child
      parent.save
      child.save
      child.parent.title.should == "Parent"
    end

    it "should have a single parent video" do
      ev = ExternalVideo.find("rockhall:fixture_pbcore_digital_document1_h2642")
      ev.parent.should be_kind_of(DigitalVideo)
    end
  end

  describe "delegate fields" do
    before :all do
      @delegate = ExternalVideo.find("rockhall:fixture_pbcore_digital_document1_h2641")
    end
    it "should be defined" do
      @delegate.mi_file_format.first.should == "MPEG-4"
    end
  end



end