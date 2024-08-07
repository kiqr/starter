class Users::Settings::TwoFactorController < Users::Settings::ApplicationController
  before_action :setup_user
  before_action :ensure_not_enabled, only: %i[new create]

  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.two_factor_setup"), user_settings_two_factor_path
  end

  def new
    # Reset the OTP secret to make sure that the user has a fresh secret key.
    # This will also reset the otp_required_for_login flag to make sure the user
    # doesn't get locked out of their account.
    @user.reset_otp_secret!

    setup_qr_code
  end

  def show; end

  def create
    if @user.validate_and_consume_otp!(params[:user][:otp_attempt])
      @user.update(otp_required_for_login: true)
      kiqr_flash_message :success, :two_factor_enabled
      redirect_to user_settings_two_factor_path
    else
      @user.errors.add(:otp_attempt, I18n.t("users.settings.two_factor.form.invalid_otp"))
      setup_qr_code
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

  def setup_qr_code
    # Generate the QR code for scanning the OTP secret.
    # We'll use the RQRCode gem to generate the QR code.
    @qr_png = RQRCode::QRCode.new(@user.otp_uri).as_svg(
      module_size: 4
    )

    @qr_code_image = @qr_png.html_safe
  end

  # Don't refresh the OTP secret if it's already enabled. This may lock the user
  # out of their account if they've already setup 2FA.
  def ensure_not_enabled
    redirect_to user_settings_two_factor_path if two_factor_enabled?
  end
end
