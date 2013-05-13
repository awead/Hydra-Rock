require "spec_helper"

describe ExternalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the sign-in page" do
      pending
    end

  end

  describe "routes" do

    describe "#new" do
      it "should route to the new action" do
        { :get => "/archival_videos/foo/external_videos/new" }.should route_to(:controller => "external_videos", :action => "new", :archival_video_id => "foo")
      end
    end

    describe "#create" do
      it "it should route to the create action" do
        { :post => "/archival_videos/foo/external_videos" }.should route_to(:controller => "external_videos", :action => "create", :archival_video_id => "foo")
      end
    end

    describe "#show" do
      it "should route to the show page" do
        {:get => "/external_videos/foo"}.should route_to(:controller => "external_videos", :id => "foo", :action => "show")
      end
    end

    describe "#edit" do
      it "should route to the edit page" do
        {:get => "/external_videos/foo/edit"}.should route_to(:controller => "external_videos", :id => "foo", :action => "edit")
      end
    end

    describe "#update" do
      it "should route to the edit page" do
        {:put => "/external_videos/foo"}.should route_to(:controller => "external_videos", :id => "foo", :action => "update")
      end
    end

    describe "#index" do
      it "should route to the index page" do
        {:get => "/archival_videos/foo/external_videos"}.should route_to(:controller => "external_videos", :archival_video_id => "foo", :action => "index")
      end
    end

  end

  describe "when the user is logged in" do

    before :each do
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns([])
      controller.stubs(:clear_session_user)
    end

    after :each do
      @user.delete
    end

    describe "#new" do
      it "should render a page for a new tape" do
        get :new, :archival_video_id => "foo"
        assert_response :success
        assigns[:afdoc].should be_kind_of ExternalVideo
      end
    end

    describe "#create" do
      it "should return an error not using an ArchivalVideo" do
        pending "creation of appropriate fixtures"
        post :create, :archival_video_id => "foo"
        puts response
      end

    end

  end

end
