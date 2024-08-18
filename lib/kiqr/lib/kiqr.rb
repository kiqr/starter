require "kiqr/engine"
require "kiqr/version"

require "devise"
require "devise-two-factor"
require "public_uid"
require "rqrcode"
require "loaf"
require "meta-tags"

require "omniauth"
require "omniauth/rails_csrf_protection"

module Kiqr
  autoload :Config, "kiqr/config"

  def self.config
    @config ||= Kiqr::Config
  end

  # ==> Base URL
  # This is used to generate absolute URLs.
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
