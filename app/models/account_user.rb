class AccountUser < ApplicationRecord # This will generate a public_uid for the model when it is created.
  # Use this public_uidas a unique public identifier for the model.
  # To find a model by its public_uid, use the following method:
  #   Account.find_puid('xxxxxxxx')
  # Learn more: https://github.com/equivalent/public_uid
  include PublicUid::ModelConcern

  # This is a list of roles that a user can have in an account.
  # You can add more roles if you want, but you SHOULD NOT REMOVE
  # the owner role, as it is required for the account to function.
  ROLES = %w[owner admin readonly]

  belongs_to :user
  belongs_to :account

  # The name of the account user.
  delegate :name, to: :user

  validates :role, presence: true, inclusion: {in: self::ROLES}
end
