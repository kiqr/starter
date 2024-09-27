require "test_helper"

class Users::Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in(@user)
  end

  test "should get edit page" do
    get user_settings_profile_path
    assert_response :success
  end

  test "can update user fields" do
    patch user_settings_profile_path, params: { user: { time_zone: "Stockholm", locale: "sv" } }
    assert_redirected_to user_settings_profile_path
    @user.reload
    assert_equal "Stockholm", @user.time_zone
    assert_equal "sv", @user.locale
  end

  test "can update personal account fields" do
    patch user_settings_profile_path, params: { user: { personal_account_attributes: { name: "Personal account name" } } }
    @user.reload

    assert_redirected_to user_settings_profile_path
    assert_equal "Personal account name", @user.personal_account.name
  end

  test "can't update personal account with invalid fields" do
    patch user_settings_profile_path(account_id: @account), params: { user: { personal_account_attributes: { name: "no" } } }
    assert_response :unprocessable_content
  end

  test "can't update user with invalid data" do
    patch user_settings_profile_path(account_id: @account), params: { user: { locale: "fi" } }
    assert_response :unprocessable_content
  end

  test "lists all available locales in locale dropdown" do
    get user_settings_profile_path
    assert_select "select[name='user[locale]']" do
      I18n.available_locales.each do |locale|
        assert_select "option[value='#{locale}']"
      end
    end
  end
end
