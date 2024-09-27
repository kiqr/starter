class OmniauthIdentity < ApplicationRecord
  include PublicUid::ModelConcern

  serialize :credentials, coder: JSON
  serialize :info, coder: JSON
  serialize :extra, coder: JSON

  # An omniauth_identity belongs to a user.
  belongs_to :user, optional: true

  # Find an omniauth_identity by its provider and a provider_uid.
  def self.from_payload(payload)
    args = { provider: payload.provider, provider_uid: payload.uid }
    where(args).first || new(args)
  end
end
