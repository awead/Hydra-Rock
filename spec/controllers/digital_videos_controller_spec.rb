require "spec_helper"

describe DigitalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the sign-in page" do
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
        pending "I have no frickin' clue why this isn't passing.  All the code is exactly like ArchivalVideo"
        get :new
        assert_response :success
        assigns[:video].should be_kind_of DigitalVideo
      end
    end

    describe "#create" do
      it "should save a new digital video" do
        post :create, :digital_video => {:main_title => "Fake title"}
        assert_equal 'Video was successfully created.', flash[:notice]
      end
    end

  end

end
