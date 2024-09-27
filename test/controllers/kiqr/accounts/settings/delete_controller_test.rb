require "test_helper"

class Accounts::Settings::DeleteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "should get show" do
    get account_settings_delete_path(account_id: @account)
    assert_response :success
  end

  # cant delete another user's account
  test "should not destroy another user's account" do
    other_account = create(:account)
    delete account_settings_delete_path(account_id: other_account)
    assert_response :forbidden
  end

  test "cannot delete account with multiple members" do
    @account.members.create(user: create(:user)) # add another member to the account

    delete account_settings_delete_path(account_id: @account)
    assert_redirected_to account_settings_delete_path(account_id: @account)
    assert_equal I18n.t("flash_messages.account_with_members_deletion_error"), flash[:alert]
  end

  test "can delete account with a single member" do
    assert_difference "Account.count", -1 do
      delete account_settings_delete_path(account_id: @account)
    end

    assert_redirected_to dashboard_path(account_id: nil)
  end

  test "only owner can delete account" do
    skip "waiting for permission checks implementation"

    # other_user = create(:user)
    # @account.members.create(user: other_user)
    # sign_in other_user

    # delete account_settings_delete_path(account_id: @account)
    # assert_response :forbidden
  end
end
