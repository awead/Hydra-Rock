source 'http://rubygems.org'

# Gems for all environments
gem 'rails', '~>3.2.8'
gem 'sass-rails'
gem 'blacklight', '~>3.6.1'
gem "hydra-head", "=5.0.0.pre2"
gem 'sqlite3'
gem 'devise'
gem 'bagit'
gem 'mediainfo'
gem 'solrizer-fedora'

# Pulling from git
gem 'rubydora', :git => 'git://github.com/cbeer/rubydora'

group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'compass-susy-plugin'
  gem 'twitter-bootstrap-rails'
  gem 'compass_twitter_bootstrap'
  gem 'therubyracer'
  gem 'jquery-rails'
end

group :development, :test do
  gem 'bcrypt-ruby'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'generator_spec'
  gem 'mocha', :require => false
  gem 'rest-client'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'ruby-debug19'
  gem 'webrat'
end

group :cucumber do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.13'
end
