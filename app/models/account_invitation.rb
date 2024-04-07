class AccountInvitation < ApplicationRecord
  # This will generate a public_uid for the model when it is created.
  # Use this public_uidas a unique public identifier for the model.
  # To find a model by its public_uid, use the following method:
  #   Account.find_puid('xxxxxxxx')
  # Learn more: https://github.com/equivalent/public_uid
  include PublicUid::ModelConcern

  belongs_to :account, inverse_of: :account_invitations, counter_cache: true

  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :email, uniqueness: {scope: :account_id, message: I18n.t("accounts.invitations.new.form.errors.email.taken")}
end
