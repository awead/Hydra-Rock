Then /^I should see the "(.*?)" dropdown menu$/ do |arg1|
  page.should have_xpath("//*/a[contains(@class, 'dropdown-toggle')]", :text => arg1)
end
