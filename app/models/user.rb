class User < ApplicationRecord
  # Default devise modules.
  devise :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable

  # Enable two-factor authentication.
  devise :two_factor_authenticatable

  # User belongs to a personal account.
  belongs_to :personal_account, class_name: "Account", optional: true, dependent: :destroy
  validates_associated :personal_account

  # User can have many team accounts.
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users

  def onboarded?
    personal_account.present? && personal_account.persisted?
  end
end
