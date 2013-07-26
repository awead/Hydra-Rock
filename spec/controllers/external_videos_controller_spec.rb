require "spec_helper"

describe ExternalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "show views should redirect to the catalog page" do
      get :show, :id => "rrhof:507"
      assert_redirected_to catalog_path("rrhof:507")
    end

    it "should redirect me to the sign-in page" do
      get :new, :archival_video_id => "foo"
      assert_redirected_to new_user_session_path
      post :create, :archival_video_id => "foo", :document_fields => { :barcode => "1234567"}
      assert_redirected_to new_user_session_path
      delete :destroy, :id => "rrhof:507"
      assert_redirected_to new_user_session_path
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

      before :all do
        @av = ArchivalVideo.new
        @av.title = "External Video creation test"
        @av.save
      end

      after :all do
        @av.destroy_external_videos
        @av.delete
      end

      it "should create a new tape from a give ArchivalVideo" do
        post :create, :archival_video_id => @av.pid, :document_fields => { :barcode => "1234567"}
        assert_equal "Tape was successfully created.", flash[:notice]
      end

      it "should fail to add a tape to an object that isn't an ArchivalVideo" do
        post :create, :archival_video_id => "rockhall:fixture_tape5", :document_fields => { :barcode => "1234567"}
        assert_equal "Can't add a tape to a ExternalVideo.", flash[:notice]
      end
    end

    describe "#index" do
      it "should render the index page" do
        get :index, :archival_video_id => "rrhof:331"
      end
    end

  end

end
