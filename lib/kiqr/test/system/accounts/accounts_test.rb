require "application_system_test_case"

class EditAccountsTest < ApplicationSystemTestCase
  test "can edit team account" do
    user = create(:user)
    team_account = create(:account, name: "Team account")
    team_account.account_users << AccountUser.create(user: user, owner: true)

    sign_in(user)
    visit edit_account_path(account_id: team_account)

    # Fill the team account form
    fill_in "account[name]", with: "Foozoo free thinkers"

    click_on "commit"
    assert_text I18n.t("kiqr.flash_messages.account_updated")

    team_account.reload
    assert_equal "Foozoo free thinkers", team_account.name
  end
end
