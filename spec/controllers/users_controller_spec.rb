require 'spec_helper'

describe UsersController do

  describe "#index" do
    it "should list all users" do
      get :index
      assert_response :success
      assigns(:users).first.name.should == "The Archivist"
    end
  end

  describe "#show" do
    it "should show one user" do
      get :show, :id => 1
      assert_response :success
      assigns(:user).name.should == "The Archivist"
      assigns(:activities).count.should == 4
    end

    it "should redirect when id returns nil" do
      get :show, :id => "bogus"
      response.code.should == "302"
      response.should redirect_to(users_path)
    end
  end

end