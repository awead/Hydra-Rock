require 'spec_helper'

describe CatalogController do

  it "should redirect to the home page for non-existent items" do
    pending
    get :show, :id => "bogus"
    assert_redirected_to root_path
    assert_equal "Resource id bogus was not found or is unavailable", flash[:notice] 
  end

end