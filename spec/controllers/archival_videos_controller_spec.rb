require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'factory_girl'

describe ArchivalVideosController do

  before do

    request.env['WEBAUTH_USER'] = 'dude'
  end

  describe "new" do
    before do
      #FactoryGirl.find_definitions
      #@user = FactoryGirl.create(:user)
      #sign_in @user
      @video = ArchivalVideo.new
      ArchivalVideo.stubs(:new).returns(@video)
    end
    it "should create a new archival video" do
      get :new
      #response.should redirect_to edit_catalog_path(@asset, :new_asset=>true)
    end

    it "should not allow you to create a video if you're not logged in" do
      pending
    end

  end

  describe "changed_fields" do
    it "should return an array of only the fields that have changed" do
      pending
    end
  end


end
