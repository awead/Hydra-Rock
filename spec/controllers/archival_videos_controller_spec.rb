require "spec_helper"

describe ArchivalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the sign-in page" do
      get :new
      assert_redirected_to new_user_session_path
      post :create
      assert_redirected_to new_user_session_path
      put :transfer, :id => "foo", :source => "bar"
      assert_redirected_to new_user_session_path
      put :assign, :id => "foo"
      assert_redirected_to new_user_session_path
      delete :destroy, :id => "foo"
      assert_redirected_to new_user_session_path
    end

  end

  describe "when the user is logged in" do

    before :each do
      @user = FactoryGirl.find_or_create(:user)
      sign_in @user
      User.any_instance.stubs(:groups).returns(["archivist"])
      controller.stubs(:clear_session_user)
    end

    after :each do
      @user.delete
    end

    describe "new" do
      it "should render a new page" do
        get :new
        assert_response :success
        assigns[:afdoc].should be_kind_of ArchivalVideo
      end
    end

    describe "#update" do

      before :each do
        @video = ArchivalVideo.new
        @video.title = "Archival Video Update Test"
        @video.save
      end

      after :each do
        @video.delete
      end

      it "should update fields with single values" do
        changes = { 
          :alternative_title => "Fake alt title",
          :event_series => "Fake series"
        }
        put :update, id: @video, wf_step: "titles", document_fields: changes
        @video.reload
        @video.alternative_title.first.should == "Fake alt title"
        @video.event_series.first.should == "Fake series"

        changes = { 
          :lc_subject => ["Sub one", "Sub two", "Sub three"],
          :rh_subject => ["RH 1", "RH 2", "RH 3"]
        }
        put :update, id: @video, wf_step: "subjects", document_fields: changes
        @video.reload
        @video.subject.length.should == 6
        @video.lc_subject.should == changes[:lc_subject]

        changes = { 
          :lc_subject => ["", "Sub two", "Sub three"],
          :alternative_title => "Fake edited alt title"
        }
        put :update, id: @video, wf_step: "subjects", document_fields: changes
        @video.reload
        @video.subject.length.should == 5
        @video.alternative_title.first.should == "Fake edited alt title"
      end

      it "should update permissions" do
        changes = { 
          :permissions => {
            "groups" => {
              "group1" => "read",
              "group2" => "edit"
            },
            "users" => {
              "user1" => "read",
              "user2" => "edit"
            }
          }
        }
        put :update, id: @video, wf_step: "permissions", document_fields: changes
        assert_equal "Permissions updated successfully", flash[:notice]
        @video.reload
        @video.edit_groups.should include("group2")
        @video.read_users.should include("user1")
      end

      it "should not update permissions if there are no changes" do
        pending
        changes = {
          :permissions => {
            :groups      => @video.rightsMetadata.groups,
            :individuals => @video.rightsMetadata.individuals
          }
        }
        put :update, id: @video, wf_step: "permissions", document_fields: changes
        assert_equal nil, flash[:notice]
      end

    end

    describe "#create" do

      it "should save a new archival video" do
        post :create, :archival_video => {:title => "Fake title"}
        assert_equal "Video was successfully created.", flash[:notice]
      end

    end

    describe "#destroy" do

      before :each do
        @video = ArchivalVideo.new
        @video.title = "Archival Video Delete Test"
        @video.save
      end

      it "should delete an archival video" do
        delete :destroy, :id => @video.pid
        assert_redirected_to catalog_index_path
        assert_equal "Deleted #{@video.pid} and associated videos", flash[:notice]
      end

    end

  end

end
