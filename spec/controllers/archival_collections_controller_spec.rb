require 'spec_helper'

describe ArchivalCollectionsController do

  include Devise::TestHelpers

  describe "#show" do
    it "should reirect to the catalog path" do
      get :show, id: "arc:0026"
      assert_redirected_to catalog_path("arc:0026")
    end
  end

  describe "#index" do
    it "should return a json listing of all colletions" do
      get :index
      assert_response :success
      # todo should be json
    end
  end

  describe "for public users" do

    describe "#new" do
      it "should redirect to the sign-in page" do
        get :new
        assert_redirected_to new_user_session_path
      end
    end

    describe "#create" do
      it "should redirect to the sign-in page" do
        post :create
        assert_redirected_to new_user_session_path
      end
    end

  end

  describe "for non-staff users" do

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
      it "should redirect to the sign-in page" do
        get :new
        assert_redirected_to root_path
        assert_equal "You are not allowed to create content", flash[:alert]
      end
    end

    describe "#create" do
      it "should redirect to the sign-in page" do
        post :create
        assert_redirected_to root_path
        assert_equal "You are not allowed to create content", flash[:alert]
      end
    end

  end  

  describe "for members of the archivist group" do

    before :each do
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns(["archivist"])
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

    describe "#new" do
      it "should render a new page" do
        get :new
        assert_response :success
        assigns[:afdoc].should be_kind_of ArchivalCollection
      end
    end

    describe "#create" do
      it "should create a new collection from the discovery solr index" do
        post :create, :archival_collection => {:pid => "ARC-0026"}
        assert_redirected_to catalog_path("arc:0026")
      end
    end

  end

end