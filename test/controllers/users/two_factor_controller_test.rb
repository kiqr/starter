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
end
