class OmniauthIdentity < ApplicationRecord
  # This will generate a public_uid for the model when it is created.
  # Use this public_uidas a unique public identifier for the model.
  # To find a model by its public_uid, use the following method:
  #   OmniauthIdentity.find_puid('xxxxxxxx')
  # Learn more: https://github.com/equivalent/public_uid
  include PublicUid::ModelConcern

  serialize :credentials, coder: JSON
  serialize :info, coder: JSON
  serialize :extra, coder: JSON

  # An omniauth_identity belongs to a user.
  belongs_to :user, optional: true

  # Find an omniauth_identity by its provider and a uid.
  def self.from_payload(payload)
    args = { provider: payload.provider, provider_uid: payload.uid }
    where(args).first || new(args)
  end
end
