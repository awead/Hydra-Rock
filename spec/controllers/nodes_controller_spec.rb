require 'spec_helper'

describe NodesController do

include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the sign-in page" do
      get :new, :archival_video_id => "rockhall:fixture_pbcore_document1"
      assert_redirected_to new_user_session_path
      post :create, :archival_video_id => "rockhall:fixture_pbcore_document1"
      assert_redirected_to new_user_session_path
    end

  end

  describe "when the user is logged in" do

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    after :each do
      sign_out @user
    end

    describe "and works with an archival video" do

      before :all do
        @video = ArchivalVideo.new
        @video.title = "Fake Title"
        @video.save
      end

      describe "#new" do
        it "should render a new page" do
          get :new, :archival_video_id => @video.pid
          assert_response :success
        end
      end

      describe "#create" do
        it "should create a new node and add it to the existing video" do
          post :create, :archival_video_id => @video.pid, :node => { "contributor" => {:name => "John Doe", :role => "author"}}
          updated = ArchivalVideo.find(@video.pid)
          updated.contributor_name.first.should == "John Doe"
          updated.contributor_role.first.should == "author"
        end

        it "should render errors for incorrect node types" do
          post :create, :archival_video_id => @video.pid, :node => { "foo" => {:bar => "baz"}}
          flash[:notice].should == "Unable to insert node: Node foo is not defined"
        end

        it "should render errors for incomplete arugments" do
          post :create, :archival_video_id => @video.pid, :node => { "contributor" => {:bar => "baz"}}
          flash[:notice].should == "Unable to insert node: Contributor name is invalid"
        end
      end

    end

    describe "and works with a digial video" do
      
      before :all do
        @digital = DigitalVideo.new
        @digital.title = "Fake Title"
        @digital.save
      end

      describe "#new" do
        it "should render a new page" do
          get :new, :digital_video_id => @digital.pid
          assert_response :success
        end
      end

      describe "#create" do
        it "should create a new node and add it to the existing video" do
          post :create, :digital_video_id => @digital.pid, :node => { "contributor" => {:name => "John Doe", :role => "author"}}
          updated = ArchivalVideo.find(@digital.pid)
          updated.contributor_name.first.should == "John Doe"
          updated.contributor_role.first.should == "author"
        end

        it "should render errors for incorrect node types" do
          post :create, :digital_video_id => @digital.pid, :node => { "foo" => {:bar => "baz"}}
          flash[:notice].should == "Unable to insert node: Node foo is not defined"
        end

        it "should render errors for incomplete arugments" do
          post :create, :digital_video_id => @digital.pid, :node => { "contributor" => {:bar => "baz"}}
          flash[:notice].should == "Unable to insert node: Contributor name is invalid"
        end
      end

    end

  end

end
