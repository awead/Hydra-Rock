source 'http://rubygems.org'

gem 'rails', '~>3.2.3'
gem 'sass-rails', "  ~> 3.2.3"

gem 'blacklight'
gem 'hydra-head', :path => "gems/hydra-head"
#gem 'hydra-head'
gem 'sqlite3'
gem 'devise'
gem 'bagit'
gem 'mediainfo'

group :assets do
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '~> 1.0.0'
  gem 'compass-susy-plugin', '~> 0.9.0'
  gem 'twitter-bootstrap-rails'
  gem 'compass_twitter_bootstrap'
  gem 'therubyracer'
  gem 'jquery-rails'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'bcrypt-ruby'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'generator_spec'

  gem 'mocha'
  gem 'rest-client'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'ruby-debug19'
  #gem 'solrizer-fedora', :path => 'gems/solrizer-fedora'
  gem 'solrizer-fedora'
  gem 'webrat'
end

group :cucumber do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end
