class Kiqr::SessionsController < Devise::SessionsController
  # prepend_before_action :configure_permitted_parameters, if: :devise_controller?
  prepend_before_action :otp_authentication, only: :create

  def new
    # New login attempts should reset the otp_user_id
    session.delete(:otp_user_id)
    super
  end

  # Override the default Devise create method and check if the user has enabled 2FA
  # If 2FA is enabled, render the OTP form page. Otherwise, proceed with the default login flow.
  def otp_authentication
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])

    if sign_in_params[:email]
      show_otp_code_form
    elsif session[:otp_user_id]
      validate_otp_code
    end
  end

  def show_otp_code_form
    # Reset the session if the user is trying to login again.
    session.delete(:otp_user_id)

    self.resource = User.find_by(email: sign_in_params[:email])
    if resource&.otp_required_for_login? && resource&.valid_password?(sign_in_params[:password])
      session[:otp_user_id] = resource.id
      render :otp, status: :unprocessable_entity
    end
  end

  def validate_otp_code
    self.resource = User.find(session[:otp_user_id])
    if resource.validate_and_consume_otp!(sign_in_params[:otp_attempt])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      resource.errors.add(:otp_attempt, :invalid)
      render :otp, status: :unprocessable_entity
    end
  end

  protected

  # Override the method to change the sign-in redirect path
  def after_sign_in_path_for(resource)
    if session[:after_sign_in_path].present?
      session.delete(:after_sign_in_path)
    elsif current_user.accounts.any?
      select_account_path
    else
      dashboard_path
    end
  end
end
