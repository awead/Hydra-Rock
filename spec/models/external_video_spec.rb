require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"

describe ExternalVideo do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @video = ExternalVideo.new
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

      ExternalVideo.expects(:load_instance).with("_non_orphan_pid_").returns(mock_non_orphan)
      ExternalVideo.expects(:load_instance).with("_orphan_pid_").returns(mock_orphan)

      ExternalVideo.garbage_collect("_non_orphan_pid_")
      ExternalVideo.garbage_collect("_orphan_pid_")
    end
  end

  describe "#link" do
    it "should return the link to EXTERNALCONTENT1 datastream" do
      pending
    end
  end

end