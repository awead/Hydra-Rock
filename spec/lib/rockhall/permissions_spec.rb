require "spec_helper"

describe Rockhall::Permissions do

  before :all do
    @video = ActiveFedora::Base.find("rockhall:fixture_pbcore_document1", :cast => true)
  end

  it "should return a permssions hash" do
    @video.permissions["groups"].should == {"public"=>"read", "donor"=>"read", "archivist"=>"edit", "reviewer"=>"edit"}
    @video.permissions["individuals"].should == {"archivist1@example.com"=>"edit"}
  end

  describe ".permissions_changed?" do
    it "should return false if permissions haven't changed" do
      params = @video.permissions
      @video.permissions_changed?(params).should be_false
    end
  
    it "should return true if permissions have changed" do
      params = @video.permissions
      params["groups"]["donor"] = "edit"
      @video.permissions_changed?(params).should be_true    
    end
  end

  describe ".update_permissions" do

    before :each do
      @test = ArchivalVideo.new
      @test.title = "Testing permissions= method"
      @test.save
    end

    after :each do
      @test.delete
    end

    it "should update permissions" do
      params = @video.permissions
      params["groups"]["donor"] = "edit"
      @test.update_permissions params
      @test.save
      @test.reload
      @test.permissions["groups"]["donor"].should == "edit"
    end

  end
  
end