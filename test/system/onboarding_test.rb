require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "full onboarding process with personal account setup" do
    visit new_user_registration_path

    fill_in "user[email]", with: "firstname.lastname@example.com"
    fill_in "user[password]", with: "th1s1sp@ssw0rd"
    fill_in "user[password_confirmation]", with: "th1s1sp@ssw0rd"
    click_on "commit"

    # It should show a message that the user has signed up but is unconfirmed.
    assert_text I18n.t("devise.registrations.signed_up_but_unconfirmed")

    # This is a hack to confirm the email for the user
    User.find_by(email: "firstname.lastname@example.com").update(confirmed_at: Time.now)

    # Login in with the newly created user
    visit new_user_session_path

    fill_in "user[email]", with: "firstname.lastname@example.com"
    fill_in "user[password]", with: "th1s1sp@ssw0rd"
    click_on "commit"

    # Should be on the onboarding_path after first sign in
    assert_current_path onboarding_path

    # Fill the personal account setup form
    fill_in "account[name]", with: "John Doe"
    # fill_in "account[my_custom_field]", with: "My custom value"

    click_on "commit"

    # Should be redirected to dashboard after successfully signing up.
    assert_current_path dashboard_path
  end
end
