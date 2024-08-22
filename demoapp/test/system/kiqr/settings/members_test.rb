require "application_system_test_case"

class EditMembersTest < ApplicationSystemTestCase
  setup do
    @account = create(:account, :with_users, users_count: 2)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "can list all members" do
    visit account_settings_members_path(account_id: @account)
    assert_selector "table tbody tr", count: 3 # One row per member
  end

  test "can invite a new member" do
    pending_count_before = @account.members.pending.count
    accepted_count_before = @account.members.accepted.count

    visit new_account_settings_member_path(account_id: @account)
    fill_in I18n.t("kiqr.accounts.settings.members.new.form.invitation_email.label"), with: "valid@email.com"
    click_on I18n.t("kiqr.accounts.settings.members.new.form.submit")

    assert_current_path account_settings_members_path(account_id: @account)
    assert_text I18n.t("flash_messages.invitation_created")

    assert_selector "table tbody tr", count: 4 # One row per member
    assert_selector "table tbody tr td", text: "valid@email.com", count: 2 # Two times, once in name column and once in email column
    assert_equal pending_count_before + 1, @account.members.pending.count
    assert_equal accepted_count_before, @account.members.accepted.count
  end
end
