require 'spec_helper'

describe ArchivalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the login page" do
      get :new
      assert_redirected_to new_user_session_path
      post :create
      assert_redirected_to new_user_session_path
    end

  end

  describe "when the user is logged in" do

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end

    describe "new" do
      it "should render a new page" do
        get :new
        assert_response :success
        assigns[:afdoc].should be_kind_of ArchivalVideo
      end
    end

    describe "#create" do
      it "should save a new archival video" do
        post :create, :archival_video => {:main_title => "Fake title"}
        assert_equal 'Video was successfully created.', flash[:notice]
      end
    end

  end

end
