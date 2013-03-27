require 'spec_helper'

describe ArchivalCollectionsController do

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
      #@request.env["devise.mapping"] = Devise.mappings[:user]
      #@user = FactoryGirl.create(:user)
      #sign_in @user
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns([])
      controller.stubs(:clear_session_user)
    end

    after :each do
      #sign_out @user
      @user.delete
    end

    describe "new" do
      it "should render a new page" do
        get :new
        assert_response :success
        assigns[:afdoc].should be_kind_of ArchivalCollection
      end
    end

  end

end