require "test_helper"

class Accounts::Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "renders the account profile edit page successfully" do
    get account_settings_profile_path(account_id: @account)
    assert_response :success
  end

  test "updates the team account name and redirects to profile page" do
    patch account_settings_profile_path(account_id: @account), params: { account: { name: "New cool name" } }
    assert_redirected_to account_settings_profile_path(account_id: @account)
    assert_equal "New cool name", @account.reload.name
  end

  test "does not update team account with invalid fields and returns error" do
    patch account_settings_profile_path(account_id: @account), params: { account: { name: "no" } }
    assert_response :unprocessable_content
  end
end
