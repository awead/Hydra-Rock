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
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns([])
      controller.stubs(:clear_session_user)
    end

    after :each do
      @user.delete
    end

    after :all do
      collection = ArchivalCollection.find("arc:0026")
      collection.delete_components
      collection.delete
    end

    describe "new" do
      it "should render a new page" do
        get :new
        assert_response :success
        assigns[:afdoc].should be_kind_of ArchivalCollection
      end

      it "should create a new collection from the discovery solr index" do
        post :create, :archival_collection => {:pid => "ARC-0026"}


      end



    end

  end

end