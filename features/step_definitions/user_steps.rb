Given /^I (?:am )?log(?:ged)? in as "([^\"]*)"$/ do |email|
  # Given %{a User exists with a Login of "#{login}"}
  user = User.create(:email => email, :password => "password", :password_confirmation => "password")
  User.find_by_email(email).should_not be_nil
  visit destroy_user_session_path
  visit new_user_session_path
  fill_in "Email", :with => email
  fill_in "Password", :with => "password"
  click_button "Sign in"
  #Then %{I should see a link to "my account info" with label "#{email}"}
  #And %{I should see a link to "logout"}
end


Given /^I am a superuser$/ do
  login = "BigWig"
  email = "bigwig@bigwig.com"
  user = User.create(:login => login, :email => email, :password => "password", :password_confirmation => "password")
  superuser = Superuser.create(:id => 20, :user_id => user.id)
  visit user_session_path(:user_session => {:login => login, :password => "password"}), :post
  visit superuser_path
end