require 'spec_helper'

describe CatalogController do

  include Devise::TestHelpers

  it "should redirect to the home page for non-existent items" do
    pending
    get :show, :id => "bogus"
    assert_redirected_to root_path
    assert_equal "Resource id bogus was not found or is unavailable", flash[:notice] 
  end

  describe "Public users" do

    it "should have access to public content" do
      get :show, :id => "rockhall:fixture_pbcore_document1"
      assert_response :success
    end
    it "should not have access to private content" do
      get :show, :id => "rrhof:507"
      assert_redirected_to new_user_session_path
      assert_equal "You do not have sufficient access privileges to read this document, which has been marked private.", flash[:alert]
    end
    
    it "should not have access to discoverable content" do
      get :show, :id => "rrhof:525"
      assert_redirected_to new_user_session_path
      assert_equal "You do not have sufficient access privileges to read this document, which has been marked private.", flash[:alert]
    end

  end

  describe "Staff users" do

    before :each do
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns(["archivist"])
      controller.stubs(:clear_session_user)
    end

    it "should have access to public content" do
      get :show, :id => "rockhall:fixture_pbcore_document1"
      assert_response :success
    end

    it "should have access to private content" do
      get :show, :id => "rockhall:fixture_pbcore_document2"
      assert_response :success
    end

    it "should have access to discoverable content" do
      get :show, :id => "rrhof:525"
      assert_response :success
    end

  end

  describe "Non-staff users" do

    before :each do
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns([])
      controller.stubs(:clear_session_user)
    end

    it "should have access to public content" do
      get :show, :id => "rockhall:fixture_pbcore_document1"
      assert_response :success
    end

    it "should not have access to private content" do
      get :show, :id => "rockhall:fixture_pbcore_document2"
      assert_redirected_to root_path
      assert_equal "You do not have sufficient access privileges to read this document, which has been marked private.", flash[:alert]
    end

    it "should not have access to discoverable content" do
      get :show, :id => "rrhof:525"
      assert_redirected_to root_path
      assert_equal "You do not have sufficient access privileges to read this document, which has been marked private.", flash[:alert]
    end

  end

end