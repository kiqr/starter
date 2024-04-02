require "test_helper"

class Users::TwoFactorControllerTest < ActionDispatch::IntegrationTest
  test "should not be able to setup 2fa if already enabled" do
    sign_in create(:user, :otp_enabled)
    get setup_two_factor_path
    assert_redirected_to edit_two_factor_path
  end

  test "secret code is refreshed on new setup" do
    user = create(:user)
    sign_in user
    get new_two_factor_path

    user.reload
    assert user.otp_secret

    get new_two_factor_path
    assert_not_equal user.otp_secret, user.reload.otp_secret
  end

  test "redirects to show page if two factor is alredy disabled" do
    user = create(:user)
    sign_in user
    get disable_two_factor_path
    assert_redirected_to edit_two_factor_path

    delete destroy_two_factor_path
    assert_redirected_to edit_two_factor_path
  end

  test "requires valid otp code to disable two factor authentication" do
    user = create(:user, :otp_enabled)
    sign_in user

    delete destroy_two_factor_path, params: {user: {otp_attempt: "123456"}}
    assert_response :unprocessable_entity
    assert_template "two_factor/disable"
    assert user.reload.otp_required_for_login?

    delete destroy_two_factor_path, params: {user: {otp_attempt: user.current_otp}}
    assert_redirected_to edit_two_factor_path
    assert_not user.reload.otp_required_for_login?
  end
end
