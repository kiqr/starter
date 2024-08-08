module Kiqr
  module Omniauthable
    extend ActiveSupport::Concern

    included do
      # OmniAuth identities for logins using external providers
      has_many :omniauth_identities, dependent: :destroy
    end
  end
end
