require "spec_helper"

describe PbcoreNodesController do

  describe "create" do
    it "should support adding new PBcore nodes" do
      pending "Test hasn't been rewritten to match new controller"
      mock_document = mock("document")
      ["publisher", "contributor","genre","topic"].each do |type|
        mock_document.expects(:insert_node).with(type).returns(["foo node","foo index"])
        mock_document.expects(:save)
        ArchivalVideo.expects(:find).with("_PID_").returns(mock_document)
        post :create, :asset_id=>"_PID_", :controller=>"pbcore", :content_type=>"archival_video", :node=>type
        response.should redirect_to edit_archival_video_path(:id=>"_PID_")
      end
    end
  end

  describe "destroy" do
    it "should support deleting PBcore nodes" do
      pending "Test hasn't been rewritten to match new controller"
      mock_document = mock("document")
      ["publisher", "contributor","genre","topic","series"].each do |type|
        mock_document.expects(:save)
        ArchivalVideo.expects(:find).with("_PID_").returns(mock_document)
        mock_document.expects(:remove_node).with(type,"0").returns("foo node")
        delete :destroy, :asset_id=>"_PID_", :content_type => "archival_video", :node=>type, :index=>"0"
      end
    end
  end

end
