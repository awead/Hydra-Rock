Then /^I should see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath('//li', :text => regexp)
  else
    assert page.has_xpath?('//li', :text => regexp)
  end

end

Then /^I should not see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should_not have_xpath('//li', :text => regexp)
  else
    assert !page.has_xpath?('//li', :text => regexp)
  end
end


Then /^I should see the facet term "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  else
    assert page.has_xpath?("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  end

end

Then /^I should be able to follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see the field title "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//label[@for='#{arg1}']", :text => arg2)
end

Then /^I should see the field content "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => arg2)
end

Then /^I should see the field content "([^"]*)" not contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => arg2)
end

Then /^I should see "([^"]*)" in italics$/ do |arg1|
  page.should have_xpath("//*/i", :text => arg1)
end

Then /^I should see the heading "([^"]*)"$/ do |arg1|
  page.should have_xpath("//*/h2[@class='section-title']", :text => arg1)
end

Then /^I should see the field content "([^"]*)" contain the current date$/ do |arg1|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => DateTime.now.strftime("%Y-%m-%d"))
end
