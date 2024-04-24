require "application_system_test_case"

class OmniauthAuthenticationTest < ApplicationSystemTestCase
  test "creates account if an account with the email does not exist" do
    visit new_user_session_path
    click_on "Login with OmniAuth"

    assert_current_path "/auth/developer"

    fill_in "name", with: "John Doe"
    fill_in "email", with: "john.doe@example.com"

    click_on "Sign In"

    assert User.find_by(email: "john.doe@example.com").present?
  end

  test "shows message if account with the current email already exist" do
    user = create(:user)
    visit new_user_session_path
    click_on "Login with OmniAuth"
    fill_in "name", with: "John Doe"
    fill_in "email", with: user.email
    click_on "Sign In"

    assert_text I18n.t("kiqr.flash_messages.omniauth_email_taken", provider: "developer")
  end

  test "can login with an already existing connection" do
    omniauth_identity = create(:omniauth_identity)
    visit new_user_session_path
    click_on "Login with OmniAuth"
    fill_in "name", with: "John Doe"
    fill_in "email", with: omniauth_identity.provider_uid
    click_on "Sign In"

    assert_current_path dashboard_path
  end
end
