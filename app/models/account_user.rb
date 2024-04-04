class AccountUser < ApplicationRecord # This will generate a public_uid for the model when it is created.
  # Use this public_uidas a unique public identifier for the model.
  # To find a model by its public_uid, use the following method:
  #   Account.find_puid('xxxxxxxx')
  # Learn more: https://github.com/equivalent/public_uid
  include PublicUid::ModelConcern

  belongs_to :user
  belongs_to :account

  # The name of the account user.
  delegate :name, to: :user

  # Prevent the deletion of account owners.
  def destroy
    return if owner?
    super
  end
end
