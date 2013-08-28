source 'http://rubygems.org'

gem 'rails'

# Hydra dependencies
gem 'blacklight' 
gem 'hydra-head'
gem 'hydra-pbcore'

# Gems for all environments
gem 'bootstrap-sass'
gem 'unicode', :platforms => [:mri_18, :mri_19]
gem 'devise-guests'
gem 'devise'
gem 'jquery-rails'
gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'
gem 'equivalent-xml'
gem 'ruby-ntlm'
gem 'public_activity'
gem 'gravatar_image_tag'
gem 'curb'

# Gems that we lock to specific versions for compatibility
# none!

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
end

group :development, :test do
  # v. 1.1.1 was giving:
  # undefined local variable or method `postgresql_version'
  # https://github.com/bmabey/database_cleaner/issues/224
  gem 'database_cleaner', '<=1.0.1'
  
  gem 'bcrypt-ruby'
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
  gem 'cucumber-rails'
  gem 'selenium-webdriver'
  gem 'launchy'
end
