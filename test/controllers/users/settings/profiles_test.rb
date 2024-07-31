require "test_helper"

class Users::Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit page" do
    user = create(:user)
    sign_in(user)
    get user_settings_profile_path
    assert_response :success
  end

  test "can update user fields" do
    user = create(:user, time_zone: "UTC", locale: "en")
    sign_in(user)

    patch user_settings_profile_path, params: { user: { time_zone: "Stockholm", locale: "sv" } }
    assert_redirected_to user_settings_profile_path
    assert_equal "Stockholm", user.reload.time_zone
    assert_equal "sv", user.reload.locale
  end

  test "can update personal account fields" do
    user = create(:user)
    sign_in user

    patch user_settings_profile_path, params: { user: { personal_account_attributes: { name: "Personal account name" } } }
    user.reload

    assert_redirected_to user_settings_profile_path
    assert_equal "Personal account name", user.personal_account.name
  end
end
