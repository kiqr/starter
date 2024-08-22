require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Load default_url_options automatically with KIQR. To set a custom URL in
    # production, set the `BASE_URL` environment variable to your apps domain.
    # It defaults to `http://localhost:3000` in the development and test environments.
    config.action_mailer.default_url_options = Kiqr.default_url_options

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # => Devise layouts
    # Set the layout for Devise controllers
    config.to_prepare do
      Devise::SessionsController.layout "public"
      Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? "application" : "public" }
      Devise::ConfirmationsController.layout "public"
      Devise::UnlocksController.layout "public"
      Devise::PasswordsController.layout "public"
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
