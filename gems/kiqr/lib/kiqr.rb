require "kiqr/engine"
require "kiqr/version"

require "devise"
require "devise-two-factor"
require "public_uid"
require "rqrcode"

require "omniauth"
require "omniauth/rails_csrf_protection"

module Kiqr
  autoload :ApplicationService, "kiqr/application_service"
  autoload :Config, "kiqr/config"
  autoload :Framework, "kiqr/framework"

  module Services
    module Teams
      autoload :Create, "kiqr/services/teams/create"
      autoload :Update, "kiqr/services/teams/update"
    end

    module Invitations
      autoload :Accept, "kiqr/services/invitations/accept"
      autoload :Create, "kiqr/services/invitations/create"
      autoload :Destroy, "kiqr/services/invitations/destroy"
      autoload :Reject, "kiqr/services/invitations/reject"
    end

    module Users
      autoload :Update, "kiqr/services/users/update"
    end
  end

  module Errors
    # Raised when an invitation has expired
    class InvitationExpired < StandardError; end
  end

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
