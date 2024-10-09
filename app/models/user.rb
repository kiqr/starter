class User < ApplicationRecord
  include Kiqr::Users::Authentication
  include Kiqr::Users::Onboarding
  include Kiqr::Users::TwoFactorAuthentication
  include Kiqr::Users::Validations
  include Kiqr::Users::Omniauth
  include Kiqr::Users::Accounts
  include Kiqr::Users::Profile

  # Delegate attributes to profile model.
  delegate :name, to: :profile
end

