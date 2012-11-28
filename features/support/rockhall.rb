# This is stuff that should get called in addition to the stuff in
# env.rb and the like, so that when you run rails f cucumber:install
# you won't have to worry about overwriting changes

require "selenium-webdriver"
Selenium::WebDriver::Firefox::Binary.path="/Users/adamw/Applications/Firefox.app/Contents/MacOS/firefox-bin"