require 'spec_helper'

describe GenericFilesController do

  include Devise::TestHelpers

  describe "our index route" do
    it "should redirect to the sign in page" do
      get :index
      assert_redirected_to new_user_session_path
    end
  end

  describe "when the user is not signed in" do
    before :each do
      @routes = Sufia::Engine.routes
    end

    describe "#show" do
      it "should redirect to the catalog controller" do
        pending "Need a generic file fixture"
        get :show, :id => "changeme:12345"
        assert_redirected_to catalog_path "changeme:12345"
      end
    end
  end



  describe "when the user is signed in" do
    
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
      @routes = Sufia::Engine.routes
      @file = GenericFile.new.tap do |f|
        f.apply_depositor_metadata(@user.user_key)
        f.title   = "Sample title"
        f.summary = "This is a summary of the file"
        f.save!
      end
    end

    after :each do
      @file.delete
    end

    describe "#edit" do
      it "should be successful" do
        get :edit, id: @file
        response.should be_successful
      end
    end

    describe "#update" do
      it "should update all fields using a parameters hash" do
        post :update, id: @file, generic_file: {
          :title             => "New Title",
          :alternative_title => ["Alt title", "Another alt title"],
          :chapter           => ["chapter 1", "chapter 2"],
          :episode           => ["foo_episode", "bar_episode"],
          :segment           => ["foo_segment", "bar_segment"],
          :subtitle          => ["foo_subtitle", "bar_subtitle"],
          :track             => ["foo_track", "bar_track"],
          :translation       => ["foo_translation", "bar_translation"],
          :lc_subject        => ["foo_subject", "bar_subject"],
          :summary           => ["foo_summary", "bar_summary"],
          :contents          => ["foo_contents", "bar_contents"],
          :lc_genre          => ["foo_genre", "bar_genre"],
          :note              => ["foo_note", "bar_note"],
          :accession_number  => ["foo_accession_number", "bar_accession_number"]
        }
        @file.reload
        @file.title.should == "New Title"
        @file.alternative_title[0].should == "Alt title"
        @file.chapter[0].should == "chapter 1"
        @file.episode[0].should == "foo_episode"
        @file.segment[0].should == "foo_segment"
        @file.subtitle[0].should == "foo_subtitle"
        @file.track[0].should == "foo_track"
        @file.translation[0].should == "foo_translation"
        @file.subject[0].should == "foo_subject"
        @file.summary[0].should == "foo_summary"
        @file.contents[0].should == "foo_contents"
        @file.genre[0].should == "foo_genre"
        @file.note[0].should == "foo_note"
        @file.accession_number[0].should == "foo_accession_number"
        @file.alternative_title[1].should == "Another alt title"
        @file.chapter[1].should == "chapter 2"
        @file.episode[1].should == "bar_episode"
        @file.segment[1].should == "bar_segment"
        @file.subtitle[1].should == "bar_subtitle"
        @file.track[1].should == "bar_track"
        @file.translation[1].should == "bar_translation"
        @file.subject[1].should == "bar_subject"
        @file.summary[1].should == "bar_summary"
        @file.contents[1].should == "bar_contents"
        @file.genre[1].should == "bar_genre"
        @file.note[1].should == "bar_note"
        @file.accession_number[1].should == "bar_accession_number"
      end

    end

  end

end