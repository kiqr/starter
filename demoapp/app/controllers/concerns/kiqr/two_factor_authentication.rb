module Kiqr
  module TwoFactorAuthentication
    extend ActiveSupport::Concern

    # This method is called before authenticating a user and will prompt the user
    # for their two-factor authentication code if they have it enabled.
    # Used in users/sessions_controller.rb and users/omniauth_controller.rb
    def authenticate_with_two_factor
      # Allow :otp_attempt to be permitted as a parameter for sign_in
      devise_parameter_sanitizer.permit(:sign_in, keys: [ :otp_attempt ])
      user = find_user

      if sign_in_params[:otp_attempt].present? && session[:otp_user_id]
        authenticate_via_otp(user)
      elsif user && user.valid_password?(sign_in_params[:password])
        prompt_for_two_factor(user)
      end
    end

    private

    def prompt_for_two_factor(user)
      @user = user # For the Devise view
      session[:otp_user_id] = user.id
      render "users/sessions/otp", status: :unprocessable_content
    end

    def authenticate_via_otp(user)
      if user.validate_and_consume_otp!(sign_in_params[:otp_attempt])
        clear_otp_attempt!
        set_flash_message!(:notice, :signed_in)
        sign_in_and_redirect user, event: :authentication
      else
        handle_otp_attempt_failure(user)
      end
    end

    def handle_otp_attempt_failure(user)
      # @todo: log failed login attempt
      kiqr_flash_message(:alert, :two_factor_failed)
      user.errors.add(:otp_attempt, :invalid)
      prompt_for_two_factor(user)
    end

    def clear_otp_attempt!
      session.delete(:otp_user_id)
    end
  end
end
