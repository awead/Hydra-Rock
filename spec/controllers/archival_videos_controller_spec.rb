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

      it "should update fields with single values" do
        video = ArchivalVideo.new
        video.title = "Another fake title"
        video.save
        changes = { 
          :alternative_title => "Fake alt title",
          :event_series => "Fake series"
        }
        put :update, id: video, document_fields: changes
        video.reload
        video.alternative_title.first.should == "Fake alt title"
        video.event_series.first.should == "Fake series"

        changes = { 
          :lc_subject => ["Sub one", "Sub two", "Sub three"],
          :rh_subject => ["RH 1", "RH 2", "RH 3"]
        }
        put :update, id: video, document_fields: changes
        video.reload
        video.subject.length.should == 6
        video.lc_subject.should == changes[:lc_subject]

        changes = { 
          :lc_subject => ["", "Sub two", "Sub three"],
          :alternative_title => "Fake edited alt title"
        }
        put :update, id: video, document_fields: changes
        video.reload
        video.subject.length.should == 5
        video.alternative_title.first.should == "Fake edited alt title"

      end

    end

    describe "#create" do

      it "should save a new archival video" do
        post :create, :archival_video => {:title => "Fake title"}
        assert_equal 'Video was successfully created.', flash[:notice]
      end

    end

  end

end
