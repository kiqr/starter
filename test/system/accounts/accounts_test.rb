require "application_system_test_case"

class EditAccountsTest < ApplicationSystemTestCase
  test "can edit personal account" do
    user = create(:user)

    sign_in(user)
    visit edit_account_path
    assert_selector("input[name='account[name]']")

    # Fill the personal account form
    fill_in_account_fields

    click_on "commit"
    assert_text I18n.t("accounts.update.success")

    user.personal_account.reload
    assert_equal "New name", user.personal_account.name
  end

  test "can edit team account" do
    user = create(:user)
    team_account = create(:account, name: "Team account")
    team_account.account_users << AccountUser.create(user: user, owner: true)

    sign_in(user)
    visit edit_account_path(account_id: team_account)

    # Fill the team account form
    fill_in_account_fields

    click_on "commit"
    assert_text I18n.t("accounts.update.success")

    team_account.reload
    assert_equal "New name", team_account.name
  end

  test "can create team account" do
    user = create(:user)

    sign_in(user)
    visit new_account_path
    assert_selector("input[name='account[name]']")

    # Fill the personal account setup form
    fill_in_account_fields

    click_on "commit"
    assert_text I18n.t("accounts.create.success")

    account = user.reload.accounts.last
    assert_equal "New name", account.name
    assert account.account_users.find_by(user: user).owner?
    assert_current_path dashboard_path(account_id: account)
  end
end
