require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase
  test "shows the you need to confirm your email message" do
    visit new_user_registration_path

    fill_in "user[email]", with: "firstname.lastname@example.com"
    fill_in "user[password]", with: "th1s1sp@ssw0rd"
    fill_in "user[password_confirmation]", with: "th1s1sp@ssw0rd"
    click_on "commit"

    assert_text I18n.t("devise.registrations.signed_up_but_unconfirmed")
  end
end
