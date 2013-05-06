require "spec_helper"

describe Rockhall::Permissions do

  before :all do
    @video = ActiveFedora::Base.find("rockhall:fixture_pbcore_document1", :cast => true)
  end

  describe ".permissions_changed?" do
    it "should return false if permissions haven't changed" do
      permissions = @video.permissions
      @video.permissions_changed?(permissions).should be_false
    end
  
    it "should return true if permissions have changed" do
      permissions = @video.permissions
      permissions << {:type => "user", :name => "foo", :access => "edit"}
      @video.permissions_changed?(permissions).should be_true    
    end
  end

  describe ".update_permissions" do

    before :each do
      @test = ArchivalVideo.new
      @test.title = "Testing update_permissions method"
      @test.save
    end

    after :each do
      @test.delete
    end

    it "should update permissions" do
      permissions = @video.permissions
      permissions << {:type => "group", :name => "donor", :access => "edit"}
      @test.update_permissions permissions
      @test.reload
      @test.edit_groups.should include("donor")
    end

  end
  
end