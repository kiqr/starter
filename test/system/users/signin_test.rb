require "application_system_test_case"

class SigninTest < ApplicationSystemTestCase
  test "signs in with a verified user" do
    user = create(:user)

    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    find(".irelia-form button[type='submit']").click

    assert_current_path dashboard_path
  end

  test "select account after sign in if user has teams" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user:, owner: true)

    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    find(".irelia-form button[type='submit']").click

    assert_current_path select_account_path
  end

  test "signs in with otp code" do
    user = create(:user, :otp_enabled)

    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    find(".irelia-form button[type='submit']").click

    fill_in "user[otp_attempt]", with: user.current_otp
    find(".irelia-form button[type='submit']").click

    assert_current_path dashboard_path
  end

  test "displays unconfirmed email message" do
    unconfirmed_user = create(:user, :unconfirmed)

    visit new_user_session_path
    fill_in "user[email]", with: unconfirmed_user.email
    fill_in "user[password]", with: unconfirmed_user.password
    find(".irelia-form button[type='submit']").click

    assert_text I18n.t("devise.failure.unconfirmed")
  end

  test "displays invalid password message" do
    user = create(:user)

    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "invalid"
    find(".irelia-form button[type='submit']").click

    assert_text I18n.t("devise.failure.invalid", authentication_keys: "Email")
  end
end
