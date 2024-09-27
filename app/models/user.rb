class User < ApplicationRecord
  include Kiqr::Users::Authentication
  include Kiqr::Users::Onboarding
  include Kiqr::Users::TwoFactorAuthentication
  include Kiqr::Users::Validations

  # Omniauth identities for social/external logins
  has_many :omniauth_identities, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :accounts, through: :members

  # Personal account
  belongs_to :personal_account, class_name: "Account", optional: true, dependent: :destroy
  accepts_nested_attributes_for :personal_account
  validates_associated :personal_account

  # Get the user's full name from their personal account.
  delegate :name, to: :personal_account
end
