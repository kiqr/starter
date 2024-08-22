require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user_with_2fa = create(:user, :otp_enabled)
  end

  test "signs in successfully if two-factor authentication is disabled" do
    post user_session_path, params: { user: { email: @user.email, password: @user.password } }

    assert_redirected_to dashboard_path
  end

  test "prompts for OTP after password if two-factor authentication is enabled" do
    post user_session_path, params: { user: { email: @user_with_2fa.email, password: @user_with_2fa.password } }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/otp"
  end

  test "signs in successfully with correct OTP when two-factor authentication is enabled" do
    post user_session_path, params: { user: { email: @user_with_2fa.email, password: @user_with_2fa.password } }
    post user_session_path, params: { user: { otp_attempt: @user_with_2fa.current_otp } }

    assert_redirected_to dashboard_path
  end

  test "fails to sign in with incorrect OTP when two-factor authentication is enabled" do
    post user_session_path, params: { user: { email: @user_with_2fa.email, password: @user_with_2fa.password } }
    post user_session_path, params: { user: { otp_attempt: "123456" } }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/otp"
  end

  test "renders login form again if password is invalid" do
    post user_session_path, params: { user: { email: @user.email, password: "randompassword" } }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/new"
  end
end
