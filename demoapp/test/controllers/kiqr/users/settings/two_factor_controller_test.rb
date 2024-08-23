require "test_helper"

class Kiqr::Users::Settings::TwoFactorControllerTest < ActionDispatch::IntegrationTest
  test "should not be able to setup 2fa if already enabled" do
    sign_in create(:user, :otp_enabled)
    get new_user_settings_two_factor_path
    assert_redirected_to user_settings_two_factor_path
  end

  test "secret code is refreshed on new setup" do
    user = create(:user)
    sign_in user
    get new_user_settings_two_factor_path

    user.reload
    assert user.otp_secret

    get new_user_settings_two_factor_path
    assert_not_equal user.otp_secret, user.reload.otp_secret
  end

  test "can view setup page" do
    sign_in create(:user)
    get new_user_settings_two_factor_path
    assert_response :success
  end

  test "does not activate 2fa with invalid verification code" do
    user = create(:user, otp_secret: User.generate_otp_secret)
    sign_in user
    post user_settings_two_factor_path, params: { user: { otp_attempt: "123456" } }
    assert_response :unprocessable_content
    assert_not user.reload.otp_required_for_login?
  end

  test "activates 2fa with valid verification code" do
    user = create(:user, otp_secret: User.generate_otp_secret)
    sign_in user
    post user_settings_two_factor_path, params: { user: { otp_attempt: user.current_otp } }
    assert_redirected_to user_settings_two_factor_path
    assert_equal I18n.t("flash_messages.two_factor_enabled"), flash[:success]
    assert user.reload.otp_required_for_login?
  end

  test "redirects to show page if two factor is alredy disabled" do
    user = create(:user)
    sign_in user

    delete user_settings_two_factor_path
    assert_redirected_to user_settings_two_factor_path
  end

  test "requires valid otp code to disable two factor authentication" do
    user = create(:user, :otp_enabled)
    sign_in user

    delete user_settings_two_factor_path, params: { user: { otp_attempt: "123456" } }
    assert_response :unprocessable_content
    assert user.reload.otp_required_for_login?

    delete user_settings_two_factor_path, params: { user: { otp_attempt: user.current_otp } }
    assert_redirected_to user_settings_two_factor_path
    assert_not user.reload.otp_required_for_login?
  end
end
