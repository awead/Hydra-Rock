source 'http://rubygems.org'

# Gems with specific versions
gem 'rails',           '~>3.2.8'
gem 'devise-guests',   '~> 0.2'
gem 'bootstrap-sass',  '~> 2.1.0.0'

# Local gems
gem 'blacklight',      :path => '/Users/adamw/Projects/Gems/blacklight'
gem 'hydra-head',      :path => '/Users/adamw/Projects/Github/hydra-head'
gem 'solrizer',        :path => '/Users/adamw/Projects/Gems/solrizer'
gem 'solrizer-fedora', :path => '/Users/adamw/Projects/Gems/solrizer-fedora'

# Gems for all environments
gem 'devise'
gem 'hydra-pbcore'
gem 'jquery-rails'
gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
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
