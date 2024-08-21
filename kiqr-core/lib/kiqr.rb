require "kiqr/version"
require "kiqr/engine"
require "kiqr/config"
require "kiqr/errors"

module Kiqr
  # Load Kiqr configuration
  def self.config
    @config ||= Kiqr::Config
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
