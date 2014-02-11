source 'http://rubygems.org'

gem 'rails', '~>4.0.0'

gem 'hydra-head'
gem 'blacklight', '< 5.0.0'
gem 'hydra-pbcore'
gem 'bootstrap-sass'
gem 'unicode', :platforms => [:mri_18, :mri_19]
gem 'devise-guests'
gem 'colorize'
gem 'jquery-rails'
gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'
gem 'equivalent-xml'
gem 'ruby-ntlm'
gem 'public_activity'
gem 'gravatar_image_tag'
gem 'curb'
gem 'devise'
gem 'artk'
gem 'mysql2'

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

  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'bcrypt-ruby'
  gem 'factory_girl'
  gem 'generator_spec'
  gem 'jettywrapper'
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
