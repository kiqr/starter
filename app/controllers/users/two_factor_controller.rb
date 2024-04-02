class Users::TwoFactorController < ApplicationController
  before_action :setup_user
  before_action :ensure_not_enabled, only: %i[new setup verify]

  def new
    # Reset the OTP secret to make sure that the user has a fresh secret key.
    # This will also reset the otp_required_for_login flag to make sure the user
    # doesn't get locked out of their account.
    @user.reset_otp_secret!

    # Redirect to the setup page to show the QR code for verification.
    redirect_to setup_two_factor_path
  end

  def setup
    # Generate the QR code for scanning the OTP secret.
    # We'll use the RQRCode gem to generate the QR code.
    @qr_png = RQRCode::QRCode.new(current_user.otp_uri).as_svg(
      module_size: 4
    )

    @qr_code_image = @qr_png.html_safe
  end

  def verify
    if @user.validate_and_consume_otp!(params[:user][:otp_attempt])
      @user.update(otp_required_for_login: true)
      redirect_to edit_two_factor_path, notice: I18n.t("users.two_factor.setup.success")
    else
      @user.errors.add(:otp_attempt, I18n.t("users.two_factor.setup.invalid_code"))
      render turbo_stream: turbo_stream.replace("two_factor_form", partial: "users/two_factor/form", locals: {user: @user})
    end
  end

  private

  # Don't refresh the OTP secret if it's already enabled. This may lock the user
  # out of their account if they've already setup 2FA.
  def ensure_not_enabled
    redirect_to edit_two_factor_path if enabled?
  end

  def setup_user
    @user = current_user
  end

  def enabled?
    current_user.otp_required_for_login?
  end
  helper_method :enabled?
end
