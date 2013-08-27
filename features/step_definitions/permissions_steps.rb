Then(/^I should see the "(.*?)" "(.*?)" permissions field title contain "(.*?)"$/) do |arg1, arg2, arg3|
  selector = "dt." + Hydra.config[:permissions][arg2.to_sym][arg1.to_sym]
  find(selector, :text => arg3)
end

Then(/^I should see the "(.*?)" "(.*?)" permissions field content contain "(.*?)"$/) do |arg1, arg2, arg3|
  selector = "dd." + Hydra.config[:permissions][arg2.to_sym][arg1.to_sym]
  find(selector, :text => arg3)
end