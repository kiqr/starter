module Kiqr
  module Models
    module OmniauthIdentity
      extend ActiveSupport::Concern
      include PublicUid::ModelConcern

      included do
        serialize :credentials, coder: JSON
        serialize :info, coder: JSON
        serialize :extra, coder: JSON

        # An omniauth_identity belongs to a user.
        belongs_to :user, optional: true
      end

      module ClassMethods
        # Find an omniauth_identity by its provider and a provider_uid.
        def from_payload(payload)
          args = { provider: payload.provider, provider_uid: payload.uid }
          where(args).first || new(args)
        end
      end
    end
  end
end
