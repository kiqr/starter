module Kiqr
  module Users
    module Omniauth
      extend ActiveSupport::Concern

      included do
        # Omniauth identities for social/external logins
        has_many :omniauth_identities, dependent: :destroy
      end
    end
  end
end
