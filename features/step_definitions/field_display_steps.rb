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

Then /^I should see the field content "([^"]*)" contain the current date$/ do |arg1|
  page.should have_xpath("//dd[@id='#{arg1}']", :text => DateTime.now.strftime("%Y-%m-%d"))
end

Then(/^I should see the following tabular display:$/) do |table|
  table.rows_hash.each do |name, value|
    page.should have_xpath("//th", :text => Solrizer.solr_name(name, :displayable))
    page.should have_xpath("//td", :text => value)
  end
end

Then(/^I should not see the field label "(.*?)" contain "(.*?)"$/) do |arg1, arg2|
  page.should_not have_xpath("//label[@for='#{arg1}']", :text => arg2)
end

Then(/^I should see the field label "(.*?)" contain "(.*?)"$/) do |arg1, arg2|
  page.should have_xpath("//label[@for='#{arg1}']", :text => arg2)
end

# Use this to view the results in a show view
#
#   And I should see the following:
#     | id                       | title               | content
#     | selector for this field  | title of the field  | content of the field
#
Then /^I should see the following:$/ do |table|
  table.hashes.each do |row|
    solr_id = Solrizer.solr_name(row["id"], :displayable)
    step %{I should see the field title "blacklight-#{solr_id}" contain "#{row["title"]}"}
    step %{I should see the field content "blacklight-#{solr_id}" contain "#{row["content"]}"}
  end
end