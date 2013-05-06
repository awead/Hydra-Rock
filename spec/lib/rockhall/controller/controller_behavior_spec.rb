require "spec_helper"

describe Rockhall::Controller::ControllerBehavior do

  class TestClass
    include Rockhall::Controller::ControllerBehavior
  end

  before :each do
    @controller = TestClass.new
  end

  describe "changed_fields" do

    before :each do
      @params = Hash.new
      @params[:id] = "rockhall:fixture_pbcore_document1"
      @params[:document_fields] = Hash.new
    end

    it "should return empty when there aren't any changes" do
      @controller.changed_fields(@params).should be_empty
    end

    it "should return names of changed single-value fields" do
      @params[:document_fields][:title] = "My Title"
      results = @controller.changed_fields(@params)
      results[:title].should == "My Title"
    end

    it "should return the permissions portion of params" do
      sample_permisisons = {
        "groups" => {"foo" => "read"},
        "users"  => {"bar" => "edit"}
      }
      @params[:document_fields][:permissions] = sample_permisisons
      results = @controller.changed_fields(@params)
      results[:permissions].should == sample_permisisons
    end

  end


describe ".format_permissions_hash" do

  it "should reformat the parameters hash so our model can use it" do
    sample_permisisons = { 
      "groups"=>{
        "uva-only"=>"none", 
        "archivist"=>"edit", 
        "donor"=>"read", 
        "reviewer"=>"edit", 
        "researcher"=>"none", 
        "patron"=>"none", 
        "admin_policy_object_editor"=>"none"
      },
      "users"=>{
        "archivist1@example.com"=>"edit"
      }
    }
    permissions_hash = @controller.format_permissions_hash(sample_permisisons)
    permissions_hash.should include({:type => "group", :name => "reviewer", :access => "edit"})
    permissions_hash.should include({:type => "user", :name => "archivist1@example.com", :access => "edit"})
    permissions_hash.should_not include({:type => "group", :name => "admin_policy_object_editor", :access => "none"})
  end

end



end