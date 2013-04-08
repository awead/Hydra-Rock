require "spec_helper"

describe User do

  before :all do
    @user = User.find_by_id(1)
  end

  describe "archivist1@example.com" do
    it "should have a name and an email" do
      @user.name.should == "The Archivist"
      @user.email.should == "archivist1@example.com"
    end
  end

  describe ".to_s" do
    it "should return the email for the user" do
      @user.to_s.should == "archivist1@example.com"
    end
  end

end