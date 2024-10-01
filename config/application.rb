require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kiqr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # ==> Application name
    # The name of the application. This will be displayed in the meta title
    # and on various places in the application.
    config.application_name = "KIQR"

    # ==> From email
    # Configure the e-mail address which will be shown in Devise::Mailer,
    # note that it will be overwritten if you use your own mailer class
    # with default "from" parameter.
    config.default_from_email = "please-change-me-at-application.rb@example.com"

    # ==> Account attributes
    # Strong parameters for account. Used for account creation and update.
    config.account_params = %i[ name ]

    # ==> User profile attributes
    # Strong parameters for user profiles. Used for user creation and update.
    config.profile_params = %i[ name ]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
