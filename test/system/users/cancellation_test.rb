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
    user = create(:user)
    team_account = create(:account, name: "Team account")
    team_account.account_users << AccountUser.create(user: user, role: "owner")

    sign_in(user)
    visit delete_user_registration_path
    accept_confirm { click_on "commit" }

    assert_text I18n.t("users.registrations.destroy.owner_of_team")
    assert User.find_by_id(user.id)
  end

  test "can't delete a user if theres an active subscription on their personal account" do
    skip("https://github.com/kiqr/kiqr/issues/1")
  end
end
