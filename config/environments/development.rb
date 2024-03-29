Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Paperclip S3 configuration
  config.paperclip_defaults = {
    :storage => :s3,
    :url=>":s3_domain_url",
    :s3_credentials => {
      :bucket=>'buck-development'
    }
  }
  port = 80
  port = Rails::Server.new.options[:Port] if defined? Rails::Server
  config.action_mailer.default_url_options = { host: 'localhost',
  port: port}
  config.action_mailer.asset_host = "http://localhost:#{port}"

  config.action_mailer.delivery_method = :letter_opener

  # Payment processing vendor
  config.payment_vendor = (ENV["PAYMENT_VENDOR"] || :dummy).to_sym

  #email debuging
  if ENV['MAILER_PASSWORD']
    config.action_mailer.default_url_options = {
      protocol: 'https',
      host: 'www.betuabuck.com'
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      user_name:            'support@betuabuck.com',
      password:             ENV['MAILER_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end
