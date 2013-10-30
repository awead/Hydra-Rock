require "spec_helper"

describe Rockhall::Models::Permissions do

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
      @test.update_permissions([{:type => "group", :name => "donor", :access => "edit"}]).should be_true
      @test.reload
      @test.edit_groups.should include("donor")
    end

  end
  
end