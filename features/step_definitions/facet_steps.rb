Then /^I should see a facet for "([^"]*)"$/ do |arg1|
  page.should have_xpath("//h5", :text => arg1)
end

Then /^I should not see a facet for "([^"]*)"$/ do |arg1|
  page.should_not have_xpath("//h5", :text => arg1)
end

Then /^I should see the facet term "([^"]*)"$/ do |arg1|
  #page.should have_xpath("//*/a[contains(@class, 'facet_select')]", :text => arg1)
  find('a.facet_select', :text => arg1)
end

Then /^I should not see the facet term "([^"]*)"$/ do |arg1|
  page.should_not have_xpath("//*/a[contains(@class, 'facet_select')]", :text => arg1)
end

Then /^I should see facets for:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do | facet |
    page.should have_xpath("//h5", :text => facet.first)
  end
end