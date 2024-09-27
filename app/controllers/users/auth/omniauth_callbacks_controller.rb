class Users::Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::SignInOut
  include TwoFactorAuthentication

  layout "public" # required for the two-factor authentication prompt

  # Define a callback method for each provider configured in the Devise initializer.
  Devise.omniauth_configs.each_key do |provider|
    # GET /auth/:provider/callback
    define_method(provider) do
      handle_auth_flow
    rescue ActiveRecord::RecordInvalid => e
      handle_email_taken_error(e)
    end
  end

  private

  def handle_auth_flow
    if user_signed_in?
      handle_signed_in_user_flow
    else
      handle_not_signed_in_user_flow
    end
  end

  def handle_signed_in_user_flow
    if omniauth_identity.user.nil?
      link_identity_to_current_user
    elsif omniauth_identity.user == current_user
      sign_in_and_redirect omniauth_identity.user, event: :authentication
    else
      kiqr_flash_message(:alert, :omniauth_identity_taken, provider: omniauth_payload.provider)

      # @todo: redirect to omniauth linked accounts page
      redirect_to dashboard_path
    end
  end

  def handle_not_signed_in_user_flow
    if omniauth_identity.user.nil?
      create_user_and_link_identity
    else
      handle_sign_in_of_existing_user(omniauth_identity.user)
    end
  end

  def link_identity_to_current_user
    omniauth_identity.user = current_user
    omniauth_identity.save!

    # @todo: redirect to omniauth linked accounts page
    redirect_to dashboard_path
  end

  def create_user_and_link_identity
    if User.exists?(email: omniauth_payload.info.email)
      kiqr_flash_message(:alert, :omniauth_email_taken, provider: omniauth_payload.provider)
      redirect_to new_user_session_path
    else
      omniauth_identity.user = User.create!(email: omniauth_payload.info.email, skip_password_validation: true)
      omniauth_identity.save!

      handle_redirect_after_sign_up(omniauth_identity.user)
    end
  end

  def handle_sign_in_of_existing_user(user)
    if user.two_factor_enabled?
      prompt_for_two_factor(user)
    else
      sign_in_and_redirect omniauth_identity.user, event: :authentication
    end
  end

  def handle_email_taken_error(exception)
    if exception.record.errors[:email]&.include?("has already been taken")
      kiqr_flash_message(:alert, :omniauth_email_taken, provider: omniauth_payload.provider)
      redirect_to new_user_session_path
    else
      raise exception
    end
  end

  def handle_redirect_after_sign_up(user)
    if user.active_for_authentication?
      sign_in_and_redirect user, event: :authentication
    else
      kiqr_flash_message :notice, :"signed_up_but_#{user.inactive_message}"
      expire_data_after_sign_in!
      redirect_to new_user_session_path
    end
  end

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
