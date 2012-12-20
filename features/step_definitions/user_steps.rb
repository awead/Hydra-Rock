# @example
#   I log in as "archivist1@example.com"
# @example
#   I am logged in as "archivist1@example.com"
Given /^I (?:am )?log(?:ged)? in as "([^\"]*)"$/ do |email|
  user = User.create(:email => email, :password => "password", :password_confirmation => "password")
  User.find_by_email(email).should_not be_nil
  visit destroy_user_session_path
  visit root_path
  find("input#user_email").set email
  find("input#user_password").set "password"
  click_button "Sign in"
end

Given /^I am logged in as "([^\"]*)" with "([^\"]*)" permissions$/ do |login,permission_group|
  step %{I am logged in as "#{login}"}
  RoleMapper.roles(login).should include permission_group
end

Given /^I am a superuser$/ do
  step %{I am logged in as "bigwig@example.com"}
  bigwig_id = User.find_by_email("bigwig@example.com").id
  superuser = Superuser.create(:id => 20, :user_id => bigwig_id)
  visit superuser_path
end

Given /^I am not logged in$/ do
  step %{I log out}
end

Given /^I log out$/ do
  visit destroy_user_session_path
end
