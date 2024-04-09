require "kiqr/engine"
require "kiqr/version"

require "devise"
require "devise-two-factor"
require "public_uid"

module Kiqr
  autoload :ApplicationService, "kiqr/application_service"
  autoload :Config, "kiqr/config"

  module Services
    module Accounts
      autoload :Create, "kiqr/services/accounts/create"
    end
  end

  def self.config
    @config ||= Kiqr::Config
  end
end
