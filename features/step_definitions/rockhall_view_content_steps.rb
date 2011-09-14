Then /^I should see the image "([^"]*)"$/ do |arg1|
	response.should have_xpath("//*/img[contains(@src, '#{arg1}')]")
end

Then /^I should see the heading "([^"]*)"$/ do |arg1|
  response.should have_xpath("//*/h2[contains(., '#{arg1}')]")
end

Then /^I should not see the heading "([^"]*)"$/ do |arg1|
  response.should_not have_xpath("//*/a[contains(., '#{arg1}')]")
end


Then /^I should see the video "([^"]*)"$/ do |arg1|
  response.should have_xpath("//*/video[contains(@src, '#{arg1}')]")
end

Then /^I should see an icon for video$/ do
  response.should have_xpath("//*/img[contains(@src, 'video_icon')]")
end
