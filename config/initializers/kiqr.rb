Kiqr::Config.configure do |config|
  # ==> Application name
  # The name of the application. This will be displayed in the meta title
  # and on various places in the application
  config.app_name = "My application"

  # ==> From email
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.default_from_email = "please-change-me-at-config-initializers@example.com"
end
