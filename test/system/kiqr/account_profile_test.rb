require "application_system_test_case"

class AccountProfileTest < ApplicationSystemTestCase
  test "can edit team profile" do
    account = create(:account, name: "Team account")
    user = create(:user, with_account: account)

    sign_in(user)
    visit account_settings_profile_path(account_id: account)


    # Fill the personal account form
    assert_selector "input[name='account[name]']", visible: :all
    fill_in "account[name]", with: "New team name"

    click_on I18n.t("accounts.settings.profiles.show.submit")
    assert_text I18n.t("flash_messages.account_profile_updated")

    account.reload

    assert_current_path account_settings_profile_path(account_id: account)
    assert_equal "New team name", account.name
  end
end
