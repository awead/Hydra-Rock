require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


# See cucumber tests (ie. /features/edit_document.feature) for more tests, including ones that test the edit method & view
# You can run the cucumber tests with
#
# cucumber --tags @edit
# or
# rake cucumber

describe SubjectsController do

  describe "create" do
    it "should support adding new subjects" do
      pending "title_info isn't working"
      mock_document = mock("document")
      ["personal","corporate","conference", "topic", "geographic"].each do |type|
        mock_document.expects(:insert_subject).with(type).returns(["foo node","foo index"])
        mock_document.expects(:save)
        ArchivalImage.expects(:find).with("_PID_").returns(mock_document)
        post :create, :asset_id=>"_PID_", :controller => "subjects", :content_type => "archival_image", :subject_type=>type
        response.should render_template "subjects/types/_edit_#{type}"
      end
    end
  end

  describe "destroy" do
    it "should support deleting subjects" do
      mock_document = mock("document")
      mock_document.expects(:save)
      ArchivalImage.expects(:find).with("_PID_").returns(mock_document)
      mock_document.expects(:remove_subject).with("0").returns("foo node")
      delete :destroy, :asset_id=>"_PID_", :content_type => "archival_image", :subject_type=>"personal", :index=>"0"
    end
  end

end
