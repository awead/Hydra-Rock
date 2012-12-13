# Enables you to use debug methods in your tests
# http://blog.mattheworiordan.com/post/9120359890/cucumber-and-capybara-webkit-automatic-screenshots

Then /take a snapshot(| and show me the page)/ do |show_me|
  page.driver.render Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
  Then %{show me the page} if show_me.present?
end