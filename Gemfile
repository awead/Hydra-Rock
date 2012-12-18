source 'http://rubygems.org'

gem 'rails',      '~>3.2.9'
gem 'hydra-head'
gem 'blacklight'    

# Hydra Bits
gem 'om'
gem 'solrizer'
gem 'hydra-file-access'
gem 'hydra-pbcore', :path => '/Users/adamw/Projects/Github/hydra-pbcore'

# Gems for all environments
gem 'bootstrap-sass'
gem "unicode", :platforms => [:mri_18, :mri_19]
gem 'devise-guests'
gem 'devise'
gem 'jquery-rails'
gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'
gem 'equivalent-xml'

# Gems that we lock to specific versions for compatibility
gem 'rubydora', '~>1.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'bcrypt-ruby'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'generator_spec'
  gem 'mocha', :require => false
  gem 'rest-client'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'debugger'
  gem 'webrat'
end

group :cucumber do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.18'
end
