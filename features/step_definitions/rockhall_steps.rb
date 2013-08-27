Then /^I should be able to follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see "([^"]*)" in italics$/ do |arg1|
  page.should have_xpath("//*/i", :text => arg1)
end

Then /^I should see the heading "([^"]*)"$/ do |arg1|
  page.should have_xpath("//h2", :text => arg1)
end

Then(/^I should not see the heading "(.*?)"$/) do |arg1|
  page.should_not have_xpath("//h2", :text => arg1)
end

Then(/^I should see the main heading "(.*?)"$/) do |arg1|
  page.should have_xpath("//h1", :text => arg1)
end

When /^I hit the enter key$/ do
  input = find("#q")
  input.base.invoke('keypress', false, false, false, false, 13, nil)
end

Then /^I should see "(.*?)" in the playlist$/ do |arg1|
  page.should have_xpath("//ul[@id='playlist']/li/a", :text => arg1)
end

Given /^I choose a title search$/ do
  page.select("Title", :from => "search_field")
end

Given /^I create a new ([^"]*)$/ do |asset_type|
  visit path_to("new #{asset_type} page")
end

Given /^I wait for (\d+) seconds$/ do |arg1|
  sleep(arg1.to_i)
end

Given /^I close the modal window$/ do
  click_button('close_modal')
end

When(/^I acccept the alert$/) do
  page.driver.browser.switch_to.alert.accept
end

Then(/^I should see "(.*?)" in the navbar$/) do |arg1|
  page.should have_xpath("//a", :text => arg1)
end

Then(/^I should not see "(.*?)" in the navbar$/) do |arg1|
  page.should_not have_xpath("//a", :text => arg1)
end
