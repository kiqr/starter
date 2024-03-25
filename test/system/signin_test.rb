require "application_system_test_case"

class SigninTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @unconfirmed_user = create(:user, :unconfirmed)
  end

  test "signs in with a verified user" do
    visit new_user_session_path
    fill_in "user[email]", with: @user.email
    fill_in "user[password]", with: @user.password
    click_on "commit"

    assert_current_path dashboard_path
  end

  test "displays unconfirmed email message" do
    visit new_user_session_path
    fill_in "user[email]", with: @unconfirmed_user.email
    fill_in "user[password]", with: @unconfirmed_user.password
    click_on "commit"

    assert_text I18n.t("devise.failure.unconfirmed")
  end

  test "displays invalid password message" do
    visit new_user_session_path
    fill_in "user[email]", with: @user.email
    fill_in "user[password]", with: "invalid"
    click_on "commit"

    assert_text I18n.t("devise.failure.invalid", authentication_keys: "Email")
  end
end
