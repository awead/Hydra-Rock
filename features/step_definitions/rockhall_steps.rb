Then /^I should be able to follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see the field title "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  selector = "dt." + arg1
  find(selector, :text => arg2)
end

Then /^I should see the field content "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  selector = "dd." + arg1
  find(selector, :text => arg2)
end

Then /^I should see the field content "([^"]*)" not contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => arg2)
end

Then /^I should see "([^"]*)" in italics$/ do |arg1|
  page.should have_xpath("//*/i", :text => arg1)
end

Then /^I should see the heading "([^"]*)"$/ do |arg1|
  page.should have_xpath("//*/legend", :text => arg1)
end

Then /^I should see the field content "([^"]*)" contain the current date$/ do |arg1|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => DateTime.now.strftime("%Y-%m-%d"))
end

When /^I hit the enter key$/ do
  input = find("#q")
  input.base.invoke('keypress', false, false, false, false, 13, nil)
end

Then /^I should see "(.*?)" in the playlist$/ do |arg1|
  page.should have_xpath("//div[@id='playlist']", :text => arg1)
end

Given /^I choose a title search$/ do
  page.select("Title", :from => "search_field")
end