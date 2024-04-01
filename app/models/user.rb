class User < ApplicationRecord
  # Include default devise modules.
  devise :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable, :two_factor_authenticatable # , :omniauthable

  # Access the users personal account.
  belongs_to :personal_account, class_name: "Account", optional: true, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users

  validates_associated :personal_account

  def onboarded?
    personal_account.present? && personal_account.persisted?
  end
end
