module Kiqr
  class Config
    include ActiveSupport::Configurable

    # ==> Application name
    # The name of the application. This will be displayed in the meta title
    # and on various places in the application.
    config_accessor :app_name, default: "KIQR"

    # ==> From email
    # Configure the e-mail address which will be shown in Devise::Mailer,
    # note that it will be overwritten if you use your own mailer class
    # with default "from" parameter.
    config_accessor :default_from_email, default: "please-change-me-at-config-initializers@example.com"
  end
end
