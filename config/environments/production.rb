HydraRock::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Rails's static asset server
  # true  = Rails built-in server will serve out your assets
  # false = Apache or other will do it for you
  #
  # This should be set to true if you want to run in production mode using
  # webrick to test things.  Otherwise, if you're in a full apache/passenger
  # environment, this should be set to false.
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Falling back to assets pipeline
  #
  # Ideally, we want all of our assets compiled so there one big, nice js and css
  # file for everything.  Occasionally, however, some files don't get compiled for one
  # reason or another.  In that case, asset pipeline can serve out those files.
  # Set to "true" if you want to allow the non-compiled files to get out via
  # asset pipeline, set to "false" if you want only the compiled stuff to be served
  # out.  Note, not using asset pipeline in production is best (ie. setting to false),
  # but sometimes certain css files won't compile so we'll set this to true and allow
  # asset pipeline in production just so things will work.
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
