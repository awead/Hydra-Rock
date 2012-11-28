source 'http://rubygems.org'

# Gems for all environments
gem 'rails', '~>3.2.9'
gem 'jquery-rails'
gem 'rspec-rails'
gem 'sass-rails'
gem 'less-rails'
gem 'blacklight'
gem 'hydra-head'
gem 'sqlite3'
gem 'devise'
gem 'bagit'
gem 'mediainfo'
gem 'solrizer-fedora'

group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'compass-susy-plugin'
  gem 'twitter-bootstrap-rails'
  gem 'compass_twitter_bootstrap'
  gem 'therubyracer'
end

group :development, :test do
  gem 'webrat'
  gem 'database_cleaner'
  gem 'debugger'
  gem 'factory_girl'
  gem 'mocha', :require => false
  gem 'capybara'
  gem 'capybara-webkit'
end

group :cucumber do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.18'
end
