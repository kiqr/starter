require "test_helper"

class Users::PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit page" do
    user = create(:user)
    sign_in(user)
    get edit_user_preferences_path
    assert_response :success
  end

  test "can update user preferences" do
    user = create(:user, time_zone: "UTC", locale: "en")
    sign_in(user)

    patch user_preferences_path, params: {user: {time_zone: "Stockholm", locale: "sv"}}
    assert_redirected_to edit_user_preferences_path
    assert_equal "Stockholm", user.reload.time_zone
    assert_equal "sv", user.reload.locale
  end
end
