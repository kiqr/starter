require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "require otp if otp is enabled" do
    user = create(:user, :otp_enabled)
    post user_session_path, params: {user: {email: user.email, password: user.password}}
    assert_response :unprocessable_entity
    assert_template "users/sessions/otp"
  end

  test "can sign in if otp is disabled" do
    user = create(:user)
    post user_session_path, params: {user: {email: user.email, password: user.password}}
    assert_response :redirect
    assert_redirected_to dashboard_path
  end
end
