require "application_system_test_case"

class EditAccountsTest < ApplicationSystemTestCase
  test "can edit personal account" do
    user = create(:user)

    sign_in(user)
    visit edit_account_path
    sleep 1

    # Fill the personal account setup form
    fill_in "account[name]", with: "New name"

    click_on "commit"
    assert_text I18n.t("accounts.update.success")

    user.personal_account.reload
    assert_equal "New name", user.personal_account.name
  end

  test "can edit team account" do
    user = create(:user)
    team_account = create(:account, name: "Team account")
    team_account.account_users << AccountUser.create(user: user, role: "owner")

    sign_in(user)
    visit edit_account_path(account_id: team_account)

    # Fill the personal account setup form
    fill_in "account[name]", with: "New team name"

    click_on "commit"
    assert_text I18n.t("accounts.update.success")

    team_account.reload
    assert_equal "New team name", team_account.name
  end
end
