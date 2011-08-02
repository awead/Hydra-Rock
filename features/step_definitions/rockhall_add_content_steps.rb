Then /^I should be able to create an asset of content type "([^"]*)"$/ do |arg1|
  get_via_redirect new_asset_path(:content_type => arg1)
end

When /^I navigate to "([^"]*)"$/ do |arg1|
  visit "http://localhost:3000/#{arg1}"
end

Then /^I should see a button for "([^"]*)"$/ do |arg1|
  response.should have_xpath("//*/input[contains(@value, '#{arg1}')]")
end


