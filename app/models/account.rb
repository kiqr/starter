class Account < ApplicationRecord
  # This will generate a public_uid for the model when it is created.
  # Use this public_uidas a unique public identifier for the model.
  # To find a model by its public_uid, use the following method:
  #   Account.find_puid('xxxxxxxx')
  # Learn more: https://github.com/equivalent/public_uid
  include PublicUid::ModelConcern

  # Name is required with a minimum length of 3 and a maximum length of 255.
  validates :name, presence: true, length: {minimum: 3, maximum: 255}

  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
end
