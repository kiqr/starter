require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "can sign in if two factor is disabled" do
    user = create(:user)
    post user_session_path, params: {user: {email: user.email, password: user.password}}
    assert_response :redirect
    assert_redirected_to dashboard_path
  end

  test "can sign in with otp if two factor is enabled" do
    user = create(:user, :otp_enabled)
    post user_session_path, params: {user: {email: user.email, password: user.password}}
    assert_response :unprocessable_entity
    assert_template "kiqr/sessions/otp"

    post user_session_path, params: {user: {otp_attempt: user.current_otp}}
    assert_redirected_to dashboard_path
  end

  test "can't sign in with invalid otp if two factor is enabled" do
    user = create(:user, :otp_enabled)
    post user_session_path, params: {user: {email: user.email, password: user.password}}
    post user_session_path, params: {user: {otp_attempt: "123456"}}
    assert_response :unprocessable_entity
    assert_template "kiqr/sessions/otp"
  end

  test "renders form again if invalid email" do
    post user_session_path, params: {user: {email: "unknown.email", password: "randompassword"}}
    assert_response :unprocessable_entity
    assert_template "kiqr/sessions/new"
  end

  test "renders form again if invalid password" do
    user = create(:user)
    post user_session_path, params: {user: {email: user.email, password: "randompassword"}}
    assert_response :unprocessable_entity
    assert_template "kiqr/sessions/new"
  end
end
