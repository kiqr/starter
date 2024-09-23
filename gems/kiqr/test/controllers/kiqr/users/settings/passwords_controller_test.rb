require "test_helper"

class Kiqr::Users::Settings::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "displays :new if password is empty" do
    user = create(:user, :without_password)
    sign_in(user)
    get user_settings_password_path
    assert_response :success
    assert_template "users/settings/passwords/new"
  end

  test "displays :edit if password is set" do
    user = create(:user)
    sign_in(user)
    get user_settings_password_path
    assert_response :success
    assert_template "users/settings/passwords/edit"
  end

  test "can create a new password" do
    user = create(:user, :without_password)
    sign_in(user)

    post user_settings_password_path, params: { user: { password: "newpassword", password_confirmation: "newpassword" } }
    assert_redirected_to user_settings_password_path
    assert user.reload.valid_password?("newpassword")
  end

  test "can update password" do
    user = create(:user)
    sign_in(user)

    patch user_settings_password_path, params: { user: { current_password: "th1s1sp4ssw0rd", password: "newpassword", password_confirmation: "newpassword" } }
    assert_redirected_to user_settings_password_path
    assert user.reload.valid_password?("newpassword")
  end

  test "can't create with invalid current_password" do
    user = create(:user)
    sign_in(user)

    patch user_settings_password_path, params: { user: { current_password: "invalid", password: "newpassword", password_confirmation: "newpassword" } }
    assert_response :unprocessable_content
    assert_not user.reload.valid_password?("newpassword")
  end
end
