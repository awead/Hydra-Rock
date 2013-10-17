HydraRock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # In development, we care.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false
end

# Sends to only interal addresses with not authenticating
ActionMailer::Base.smtp_settings = {
  :address => "192.168.250.174",
  :port    => 25,
  :domain  => 'ROCKHALL',
}

ActionMailer::Base.default :from => 'library@rockhall.org'

# Use Pry instead of IRB
silence_warnings do
  require 'pry'
  IRB = Pry
end