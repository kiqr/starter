module Kiqr
  class OmniauthController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[callback]
    skip_before_action :ensure_onboarded, only: %i[callback]
    skip_before_action :verify_authenticity_token, only: %i[callback]

    # GET /auth/:provider/callback
    def callback
      omniauth_identity.assign_attributes(omniauth_attributes)
      create_or_assign_user if omniauth_identity.user.nil?
      omniauth_identity.save!
      sign_in_and_redirect omniauth_identity.user, event: :authentication
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.errors[:email]&.include?("has already been taken")
      kiqr_flash_message(:alert, :omniauth_email_taken, provider: omniauth_payload.provider)
      redirect_to new_user_session_path
    end

    private

    def create_or_assign_user
      omniauth_identity.user = if user_signed_in?
        current_user
      else
        user = User.new(email: omniauth_payload.info.email)
        user.save(validate: false)
        user
      end
    end

    # Get the omniauth payload from the request environment
    def omniauth_payload
      @omniauth_payload ||= request.env["omniauth.auth"]
    end

    def omniauth_identity
      @omniauth_identity ||= OmniauthIdentity.from_payload(omniauth_payload)
    end

    def omniauth_attributes
      expires_at = omniauth_payload.credentials.expires_at.present? ? Time.at(omniauth_payload.credentials.expires_at) : nil
      {
        credentials: omniauth_payload.credentials,
        info: omniauth_payload.info,
        extra: omniauth_payload.extra,
        expires_at: expires_at
      }
    end
  end
end
