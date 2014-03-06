require "spec_helper"

describe Rockhall::Models::Permissions do

  before :each do
    @test = ArchivalVideo.new
    @test.title = "Testing update_permissions method"
    @test.save
  end

  after :each do
    @test.delete
  end

  describe ".update_permissions" do

    it "should update permissions and return true" do
      @test.update_permissions([{:type => "group", :name => "donor", :access => "edit"}]).should be_true
      @test.reload
      @test.edit_groups.should include("donor")
    end

  end

  describe ".is_discoverable?" do

    it "should return false" do
      @test.is_discoverable?.should be_false
    end

    it "should return true if the discover group includes public" do
      video = ArchivalVideo.find("rrhof:525")
      video.is_discoverable?.should be_true
    end

    it "should return true if the read group includes public" do
      video = ArchivalVideo.find("rockhall:fixture_pbcore_document5")
      video.is_discoverable?.should be_true
    end

  end
  
end
