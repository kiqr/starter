module Kiqr
  module Users
    module Omniauthable
      extend ActiveSupport::Concern

      included do
        devise :omniauthable
        has_many :omniauth_identities, dependent: :destroy
      end
    end
  end
end
