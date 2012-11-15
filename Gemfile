source 'http://rubygems.org'

gem 'rails',           '~>3.2.8'

# Local gems
gem 'blacklight'     #:path => '/Users/adamw/Projects/Gems/blacklight'
gem 'hydra-head', '~> 5.0.0.pre12'     #:path => '/Users/adamw/Projects/Github/hydra-head'
gem 'om'              #:path => '/Users/adamw/Projects/Github/om'
gem 'solrizer'        #:path => '/Users/adamw/Projects/Github/solrizer'
gem 'hydra-pbcore',    :path => '/Users/adamw/Projects/Github/hydra-pbcore'

# Hydra add-ins
gem 'hydra-file-access'
gem 'solrizer-fedora', :git  => 'https://github.com/projecthydra/solrizer-fedora'

# Gems for all environments
gem 'bootstrap-sass',  '~> 2.1.0.0'
gem 'devise-guests',   '~> 0.2'
gem 'devise'
gem 'jquery-rails'
gem 'sqlite3'
gem 'bagit'
gem 'mediainfo'
gem 'equivalent-xml'

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
  gem 'debugger'
  gem 'webrat'
end

group :cucumber do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.18'
end
