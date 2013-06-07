require 'spec_helper'

describe HeadingsController do

  describe "#index" do
    it "should default to subhect headings" do
      get :index, :q => "Rock"
      assigns(:headings).should_not be_nil
    end

    it "should return subject headings" do
      get :index, :q => "Rock", :term => "subject"
      assigns(:headings).should_not be_nil
    end

    it "should return genre headings" do
      get :index, :q => "Rock", :term => "genre"
      assigns(:headings).should_not be_nil
    end

    it "should return name headings" do
      get :index, :q => "Hun", :term => "name"
      assigns(:headings).should_not be_nil
    end

  end

end