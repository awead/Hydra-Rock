require "spec_helper"

describe Rockhall::Controller::ControllerBehavior do

  class TestClass
    include Rockhall::Controller::ControllerBehavior
  end

  before :each do
    @controller = TestClass.new
  end

  describe ".format_permissions_hash" do
  
    it "should reformat the parameters hash so our model can use it" do
      sample_permisisons = { 
        "groups"=>{
          "uva-only"=>"none", 
          "archivist"=>"edit", 
          "donor"=>"read",  
          "researcher"=>"none", 
          "patron"=>"none", 
          "admin_policy_object_editor"=>"none"
        },
        "users"=>{
          "archivist1@example.com"=>"edit"
        }
      }
      permissions_hash = @controller.format_permissions_hash(sample_permisisons)
      permissions_hash.should include({:type => "user", :name => "archivist1@example.com", :access => "edit"})
      permissions_hash.should include({:type => "group", :name => "admin_policy_object_editor", :access => "none"})
    end
  
  end



end