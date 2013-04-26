require 'spec_helper'

describe NodesController do

include Devise::TestHelpers

  describe "with an unauthenticated user" do

    it "should redirect to the sign-in page" do
      get :new, :id => "rockhall:fixture_pbcore_document1"
      assert_redirected_to new_user_session_path
      post :create, :id => "rockhall:fixture_pbcore_document1"
      assert_redirected_to new_user_session_path
    end

  end

  describe "with an authenticated user" do

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    after :each do
      sign_out @user
    end

    describe "and an ArchivalVideo using" do

      before :all do
        @video = ArchivalVideo.new
        @video.title = "Fake Title"
        @video.save
      end

      describe "#new" do
        it "should render a new contributor page" do
          get :new, :id => @video.pid, :type => "contributor"
          assert_response :success
        end
        it "should require a node type" do
          get :new, :id => @video.pid
          flash[:notice].should == "Node type is required"
        end
      end

      describe "#create" do
        it "should create a new node and add it to the existing video" do
          post :create, :id => @video.pid, :type => "contributor", :name => "John Doe", :role => "author"
          updated = ArchivalVideo.find(@video.pid)
          updated.contributor_name.first.should == "John Doe"
          updated.contributor_role.first.should == "author"
        end

        it "should render errors for incorrect node types" do
          post :create, :id => @video.pid, :type => "foo", :bar => "baz"
          flash[:notice].should == "Unable to insert node: Node foo is not defined"
        end

        it "should render errors for incomplete arugments" do
          post :create, :id => @video.pid, :type => "contributor", :bar => "baz"
          flash[:notice].should == "Unable to insert node: Contributor name is invalid"
        end
      end

    end

  end

end
