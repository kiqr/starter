# Rails dependencies
require "rails"
require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

# Core dependencies
require "devise"
require "devise-two-factor"
require "omniauth"
require "omniauth/rails_csrf_protection"
require "public_uid"

# Frontend dependencies
require "meta-tags"
require "loaf"
require "rqrcode"

# Kiqr dependencies
require "kiqr/version"
require "kiqr/config"
require "kiqr/engine"
require "kiqr/errors"
require "kiqr/rails/routes"
require "kiqr/translations"

module Kiqr
  autoload :CurrentAttributes, "kiqr/current_attributes"

  module Controllers
    autoload :Helpers, "kiqr/controllers/helpers"
    autoload :SetCurrentRequestDetails, "kiqr/controllers/set_current_request_details"
    autoload :TwoFactorAuthentication, "kiqr/controllers/two_factor_authentication"
    autoload :UrlHelpers, "kiqr/controllers/url_helpers"
  end

  module Models
    autoload :Account, "kiqr/models/account"
    autoload :Member, "kiqr/models/member"
    autoload :OmniauthIdentity, "kiqr/models/omniauth_identity"
    autoload :User, "kiqr/models/user"
  end

  # Load Kiqr configuration
  def self.config
    @config ||= Kiqr::Config
  end

  # Return the Kiqr version
  def self.version
    Kiqr::VERSION
  end

  # Include helpers to the applications controllers and views.
  def self.include_helpers(scope)
    ActiveSupport.on_load(:action_controller) do
      include scope::Helpers if defined?(scope::Helpers)
      include scope::UrlHelpers if defined?(scope::UrlHelpers)
    end

    ActiveSupport.on_load(:action_view) do
      include scope::UrlHelpers if defined?(scope::UrlHelpers)
      include scope::FormHelpers if defined?(scope::FormHelpers)
      include scope::ViewHelpers if defined?(scope::ViewHelpers)
    end
  end

  # ==> Base URL
  # Load default_url_options automatically with KIQR. To set a custom URL in
  # production, set the `BASE_URL` environment variable to your apps domain.
  # It defaults to `http://localhost:3000` in the development and test environments.
  def self.default_url_options
    ENV["BASE_URL"] ||= (Rails.env.development? || Rails.env.test?) ? "http://localhost:3000" : (return {})

    parsed_base_url = URI.parse(ENV["BASE_URL"])
    default_url_options = %i[user password host port].index_with { |key| parsed_base_url.public_send(key) }.compact
    default_url_options[:protocol] = parsed_base_url.scheme

    # Remove port 80 or port 443 from default_url_options
    default_url_options.delete(:port) if default_url_options[:port] == 80 || default_url_options[:port] == 443

    raise "ENV['BASE_URL'] has not been configured correctly." if default_url_options.empty?

    default_url_options
  end
end
