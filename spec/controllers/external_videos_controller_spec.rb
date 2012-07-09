#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'spec_helper'

describe ExternalVideosController do

  include Devise::TestHelpers

  describe "when the user is not logged in" do

    it "should redirect me to the login page" do
      pending
    end

  end

end
