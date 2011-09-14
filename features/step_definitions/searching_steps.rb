require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# Gives a way to test how many items are on a given page either gallery or list
Then /^I should see (\d+) (gallery|list) results$/ do |number,type|
  if type == "gallery"
    results_num = response.body.scan(/<div class=\"document thumbnail\">/).length
  elsif type == "list"
    results_num = response.body.scan(/<tr class=\"document (odd|even)\">/).length
  else
    results_num = -1
  end
  results_num.should == number.to_i
end

# simple way to check for elements in the dom (needed for per_page bug check)
Then /^I (should not|should) see an? "([^\"]*)" tag with an? "([^\"]*)" attribute of "([^\"]*)"$/ do |bool,tag,attribute,value|
  if bool == "should not"
    response.should_not have_tag("#{tag}[#{attribute}*=?]", /^.*#{value}.*$/)
  else
    response.should have_tag("#{tag}[#{attribute}*=?]", /^.*#{value}.*$/)
  end
end