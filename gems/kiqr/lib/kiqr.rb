require "kiqr/engine"
require "kiqr/version"

require "devise"
require "devise-two-factor"
require "public_uid"

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
end
