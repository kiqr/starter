require "test_helper"

class Accounts::Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account, :with_users, users_count: 2)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "should get edit page" do
    get account_settings_profile_path(account_id: @account)
    assert_response :success
  end

  test "can update team account fields" do
    patch account_settings_profile_path(account_id: @account), params: { account: { name: "New cool name" } }
    @account.reload

    assert_redirected_to account_settings_profile_path(account_id: @account)
    assert_equal "New cool name", @account.name
  end

  test "can't update team account with invalid fields" do
    patch account_settings_profile_path(account_id: @account), params: { account: { name: "no" } }
    assert_response :unprocessable_content
  end
end
