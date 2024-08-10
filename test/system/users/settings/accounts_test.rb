require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  test "can create team account" do
    user = create(:user)

    sign_in(user)
    visit new_user_settings_account_path
    assert_selector("input[name='account[name]']")

    # Fill the team account form
    fill_in "account[name]", with: "Foobar code warriors"

    click_on I18n.t("users.settings.accounts.new.submit")
    assert_text I18n.t("flash_messages.account_created")

    account = user.reload.accounts.last
    assert_equal "Foobar code warriors", account.name
    assert account.account_users.find_by(user: user).owner?
    assert_current_path dashboard_path(account_id: account)
  end
end
