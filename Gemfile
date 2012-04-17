source 'http://rubygems.org'

gem 'rails', '~>3.2.2'
gem 'sass-rails', "  ~> 3.2.3"

gem 'blacklight'
gem 'hydra-head', :path => "gems/hydra-head"
gem 'sqlite3'
gem 'devise'
gem 'bagit'
gem 'mediainfo'

group :assets do
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '~> 1.0.0'
  gem 'compass-susy-plugin', '~> 0.9.0'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'bcrypt-ruby'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'generator_spec'
  gem 'jquery-rails'
  gem 'mocha'
  gem 'rest-client'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'ruby-debug19'
  gem 'solrizer-fedora', :path => 'gems/solrizer-fedora'
  gem 'webrat'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end
