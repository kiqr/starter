class Users::Auth::SessionsController < Devise::SessionsController
  include TwoFactorAuthentication

  before_action :authenticate_with_two_factor, if: -> { action_name == "create" && two_factor_enabled? }

  private

  def two_factor_enabled?
    find_user&.two_factor_enabled?
  end

  def find_user
    if sign_in_params[:email]
      User.find_by(email: sign_in_params[:email])
    elsif session[:otp_user_id]
      User.find(session[:otp_user_id])
    end
  end
end
