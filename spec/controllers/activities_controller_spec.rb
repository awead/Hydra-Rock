require 'spec_helper'

describe ActivitiesController do

  describe "#index" do

    it "should return all activities" do
      get :index
      assert_response :success
      assigns(:activities).count.should == 4
    end

  end

end