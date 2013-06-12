require "spec_helper"

describe Rockhall::Permissions do

  before :all do
    @video = ActiveFedora::Base.find("rockhall:fixture_pbcore_document1", :cast => true)
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

    it "should update permissions and return true" do
      permissions = @video.permissions
      permissions << {:type => "group", :name => "donor", :access => "edit"}
      @test.update_permissions(permissions).should be_true
      @test.reload
      @test.edit_groups.should include("donor")
    end

    it "should return false when there are no changes" do
      pending "Need to find a nice way of determining if permissions have changed"
    end

  end
  
end