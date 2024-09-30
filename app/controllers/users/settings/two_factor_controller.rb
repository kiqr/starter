class Users::Settings::TwoFactorController < Users::Settings::BaseController
  before_action :setup_user
  before_action :ensure_not_enabled, only: %i[new create]

  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.users.two_factor.root"), user_settings_two_factor_path
  end

  def new
    # Reset the OTP secret to make sure that the user has a fresh secret key.
    # This will also reset the otp_required_for_login flag to make sure the user
    # doesn't get locked out of their account.
    @user.reset_otp_secret!
  end

  def show; end

  def create
    if @user.validate_and_consume_otp!(params[:user][:otp_attempt])
      @user.update(otp_required_for_login: true)
      kiqr_flash_message :success, :two_factor_enabled
      redirect_to user_settings_two_factor_path
    else
      @user.errors.add(:otp_attempt, I18n.t("users.settings.two_factor.form.invalid_otp"))
      render turbo_stream: turbo_stream.replace("two_factor_form", partial: "users/settings/two_factor/form", locals: { user: @user }), status: :unprocessable_content
    end
  end

  def destroy
    return redirect_to user_settings_two_factor_path unless two_factor_enabled?

    if @user.validate_and_consume_otp!(params.dig(:user, :otp_attempt))
      @user.update(otp_required_for_login: false, otp_backup_codes: [])
      kiqr_flash_message :success, :two_factor_disabled
      redirect_to user_settings_two_factor_path
    else
      @user.errors.add(:otp_attempt, I18n.t("users.settings.two_factor.form.invalid_otp"))
      render :show, status: :unprocessable_content
    end
  end

  private

  def two_factor_enabled?
    current_user.otp_required_for_login?
  end
  helper_method :two_factor_enabled?

  # Don't refresh the OTP secret if it's already enabled. This may lock the user
  # out of their account if they've already setup 2FA.
  def ensure_not_enabled
    redirect_to user_settings_two_factor_path if two_factor_enabled?
  end
end
