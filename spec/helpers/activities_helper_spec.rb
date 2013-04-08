require 'spec_helper'

describe ActivitiesHelper do

  describe ".render_activity_icon" do
    it "should return an icon for a given action" do
      helper.render_activity_icon("foo").should     == "unknown"
      helper.render_activity_icon("create").should  == '<i class="icon-file"></i>'
      helper.render_activity_icon("updated").should == '<i class="icon-pencil"></i>'
      helper.render_activity_icon("delete").should  == '<i class="icon-trash"></i>'
    end
  end

  describe ".render_activity_owner" do
    it "should return a string for an unknown owner" do
      helper.render_activity_owner(PublicActivity::Activity.new).should == "Someone"
    end

    it "should return a link the user" do
      helper.render_activity_owner(PublicActivity::Activity.find_by_id(1)).should == '<a href="/users/1">The Archivist</a>'
    end
  end

  describe ".render_activity_message" do
    it "should return nil for missing parameters" do
      helper.render_activity_message({}).should be_nil
      helper.render_activity_message({"action" => nil}).should be_nil
    end

    it "should return a default message for unknown parameters" do
      helper.render_activity_message({"action" => ""})      == "some other kind of activity"
      helper.render_activity_message({"action" => "bogus"}) == "some other kind of activity"
    end

    it "should return a message for a new video" do
      parameters = { "action" => "create", "title" => "Some title", "pid" => "pid" }
      helper.render_activity_message(parameters).should match(/created a new video/)
    end

  end
  
end