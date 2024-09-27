require "application_system_test_case"

class CancellationTest < ApplicationSystemTestCase
  test "can delete a fresh user" do
    user = create(:user)
    sign_in(user)
    visit delete_user_registration_path
    accept_confirm { click_on I18n.t("users.auth.registrations.delete.submit") }
    assert_text I18n.t("devise.registrations.destroyed")
    assert_nil User.find_by_id(user.id)
  end

  test "don't show delete button if user is an owner of a team" do
    account = create(:account, name: "Team account")
    user = create(:user, with_account: account)

    sign_in(user)
    visit delete_user_registration_path
    assert_no_selector("a", text: I18n.t("users.auth.registrations.delete.submit"))
  end
end
