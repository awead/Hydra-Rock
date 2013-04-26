source 'http://rubygems.org'

gem 'rails',      '~>3.2.11'
gem 'hydra-head', '< 6.0.0'
gem 'blacklight'    

# Hydra Bits
gem 'om'
gem 'solrizer'
gem 'hydra-pbcore'
gem 'solr_ead'

# Gems for all environments
gem 'bootstrap-sass'
gem 'unicode', :platforms => [:mri_18, :mri_19]
gem 'devise-guests'
gem 'devise'

gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'
gem 'equivalent-xml'
gem 'ruby-ntlm'
gem 'public_activity'
gem 'gravatar_image_tag'

# Gems that we lock to specific versions for compatibility

# jquery-rails 2.2 uses jQuery 1.9 which removed .live()
# we're still using that and need to update our js, so until then,
# we'll stick with an older version.
gem 'jquery-rails', '< 2.2.0'

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
  gem 'database_cleaner'
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
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'selenium-webdriver'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.18'
end
