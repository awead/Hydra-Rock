require 'spec_helper'

describe NodesController do

include Devise::TestHelpers

  describe "with an unauthenticated user" do

    it "should redirect to the sign-in page" do
      get :new, :id => "rockhall:fixture_pbcore_document1", :type => "foo"
      assert_redirected_to new_user_session_path
      post :create, :id => "rockhall:fixture_pbcore_document1", :type => "foo"
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
        @video = ArchivalVideo.new(:pid => "nodes-controller-spec:1")
        @video.title = "Fake Title"
        @video.save
      end
  
      after :all do
        ActiveFedora::Base.find("nodes-controller-spec:1").delete
      end

      describe "#new" do
        it "should render a new contributor page" do
          get :new, :id => @video.pid, :type => "contributor"
          assert_response :success
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

        describe "new events" do
          it "should add event series" do
            post :create, :id => @video.pid, :type => "event", :event_type => "series", :event_value => "Some series"
            updated = ArchivalVideo.find(@video.pid)
            updated.event_series.first.should == "Some series"
            assert_redirected_to edit_node_path(updated.pid, "event")
          end 
        end

      end

      describe "#delete" do
        it "should remove a node of a give type and index" do
          @video.new_contributor(:name => "Person to be deleted")
          @video.save
          delete :destroy, :id => @video.pid, :type => "contributor", :index => 0
          @video.reload
          @video.contributor_name.should be_empty
          assert_redirected_to edit_node_path(@video.pid, "contributor")
        end
      end

    end

  end

  describe "routes" do

    it "#new" do
      assert_generates "/nodes/rrhof:1234/foo/new", { :controller => "nodes", :action => "new", :id => "rrhof:1234", :type => "foo" }
    end

    it "#edit" do
      assert_generates "/nodes/rrhof:1234/foo/edit", { :controller => "nodes", :action => "edit", :id => "rrhof:1234", :type => "foo" }
    end

    it "#create" do
      assert_routing({ :path => "nodes/rrhof:1234/foo", :method => :post }, { :controller => "nodes", :action => "create", :id => "rrhof:1234", :type => "foo" })
    end

    it "#destroy" do
      assert_routing({ :path => "nodes/rrhof:1234/foo/0", :method => :delete }, { :controller => "nodes", :action => "destroy", :id => "rrhof:1234", :type => "foo", :index => "0" })
    end

  end

end
