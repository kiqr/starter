require "application_system_test_case"

class EditAccountsTest < ApplicationSystemTestCase
  test "can delete a fresh user" do
    user = create(:user)
    sign_in(user)
    visit delete_user_registration_path
    accept_confirm { click_on "commit" }

    assert_text I18n.t("devise.registrations.destroyed")
    assert_nil User.find_by_id(user.id)
  end

  test "can't delete a user if they're an owner of a team" do
    skip("https://github.com/kiqr/kiqr/issues/1")
  end

  test "can't delete a user if theres an active subscription on their personal account" do
    skip("https://github.com/kiqr/kiqr/issues/1")
  end
end
