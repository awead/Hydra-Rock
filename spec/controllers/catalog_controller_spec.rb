require 'spec_helper'

describe CatalogController do

  it "should redirect to the home page for non-existent items" do
    pending
    get :show, :id => "bogus"
    assert_redirected_to root_path
    assert_equal "Resource id bogus was not found or is unavailable", flash[:notice] 
  end

  it "should redirect to the sign-in page when accessing private content" do
    get :show, :id => "rrhof:507"
    assert_redirected_to new_user_session_path
    assert_equal "You do not have sufficient access privileges to read this document, which has been marked private.", flash[:alert]
  end

end