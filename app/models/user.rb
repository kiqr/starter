class User < ApplicationRecord
  include Kiqr::Users::Authentication
  include Kiqr::Users::Onboarding
  include Kiqr::Users::TwoFactorAuthentication
  include Kiqr::Users::Validations
  include Kiqr::Users::Omniauth

  # Profile with name, avatar and other details.
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  validates_associated :profile

  # Delegate attributes to profile model.
  delegate :name, to: :profile

  # Accounts and memberships
  has_many :members, dependent: :destroy
  has_many :accounts, through: :members

  # Omniauth identities for social/external logins
  has_many :omniauth_identities, dependent: :destroy
end
