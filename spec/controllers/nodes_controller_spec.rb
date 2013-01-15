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

    describe "and a DigitalVideo using" do
      
      before :all do
        @digital = DigitalVideo.new
        @digital.title = "Fake Title"
        @digital.save
      end

      describe "#new" do
        it "should render a new page" do
          get :new, :id => @digital.pid, :type => "contributor"
          assert_response :success
        end
        it "should require a node type" do
          get :new, :id => @digital.pid
          flash[:notice].should == "Node type is required"
        end
      end

      describe "#create" do
        it "should create a new node and add it to the existing video" do
          post :create, :id => @digital.pid, :type => "contributor", :name => "John Doe", :role => "author"
          updated = ArchivalVideo.find(@digital.pid)
          updated.contributor_name.first.should == "John Doe"
          updated.contributor_role.first.should == "author"
        end

        it "should render errors for incorrect node types" do
          post :create, :id => @digital.pid, :type => "foo", :bar => "baz"
          flash[:notice].should == "Unable to insert node: Node foo is not defined"
        end

        it "should render errors for incomplete arugments" do
          post :create, :id => @digital.pid, :type => "contributor", :bar => "baz"
          flash[:notice].should == "Unable to insert node: Contributor name is invalid"
        end
      end

      describe "#destroy" do

        it "should delete a node from a given index" do
          pending "This works when it's run individually, but not with all the other tests"
          digital = DigitalVideo.new
          digital.title = "Fake Title"
          digital.save
          digital.new_contributor({:name => "Foo"})
          digital.save
          digital.contributor_name.first.should == "Foo"
          delete :destroy, :type => "contributor", :id => digital.pid, :index => 0
          updated = DigitalVideo.find(digital.pid)
          updated.contributor_name.first.should be_nil
        end

      end

    end

  end

end
