source 'http://rubygems.org'

gem 'rails',      '~>3.2.13'

# Hydra dependencies
gem 'blacklight' 
gem 'hydra-head'
gem 'hydra-pbcore', :path => '/Users/adamw/Projects/Github/hydra-pbcore'

# Gems for all environments
gem 'bootstrap-sass'
gem 'unicode', :platforms => [:mri_18, :mri_19]
gem 'devise-guests'

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
#
# Don't use devise 3.0 just yet: https://github.com/plataformatec/devise/issues/2515
gem 'devise', '< 3.0.0'


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
  gem 'bcrypt-ruby'

  # v. 1.1.1 was giving:
  # undefined local variable or method `postgresql_version'
  gem 'database_cleaner', '< 1.1.1'
  
  gem 'factory_girl'
  gem 'generator_spec'
  gem 'mocha', :require => false
  gem 'rest-client'
  gem 'rspec', '~> 2.12.0'
  gem 'rspec-rails'
  gem 'debugger'
  gem 'webrat'
end

group :cucumber do
  gem 'cucumber-rails'
  gem 'selenium-webdriver'
  gem 'launchy'
end
