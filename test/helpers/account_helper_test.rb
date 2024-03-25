require "test_helper"

class AccountHelperTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "current_account returns the user personal account when account_id param is blank" do
    sign_in @user
    get dashboard_path
    assert_equal assigns(:current_account), @user.personal_account
  end

  test "current_account returns nil when not signed in" do
    get root_path
    assert_nil assigns(:current_account)
  end
end
