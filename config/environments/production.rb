Gocongress::Application.configure do

  # Settings specified here will take precedence over those in
  # config/application.rb.

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.compress = true

  # Specifies the header that your server uses for sending files.
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx


  # Disable delivery errors, bad email addresses will be ignored.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => "www.gocongress.org" }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Runtime exception notification
  config.middleware.use ExceptionNotifier,
    sender_address: 'usgcwebsite@gmail.com',
    exception_recipients: 'jared@jaredbeck.com'

end
