require "test_helper"

class AccountHelperTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @company_account = create(:account, name: "Company 1")
    @alien_account = create(:account, name: "Someone else's account")
    @user.account_users << AccountUser.new(account: @company_account, role: "owner")
  end

  test "current_account returns the user personal account when account_id param is blank" do
    sign_in @user
    get dashboard_path
    assert_equal assigns(:current_account), @user.personal_account
  end

  test "current_account returns the company account when account_id param is set" do
    sign_in @user
    get dashboard_path(account_id: @company_account)
    assert_equal assigns(:current_account), @company_account
  end

  test "current_account can only return accounts owned by the user" do
    sign_in @user
    assert_raise(ActionView::Template::Error) {
      get dashboard_path(account_id: @alien_account)
      assigns(:current_account)
    }
  end

  test "current_account returns nil when not signed in" do
    get root_path
    assert_nil assigns(:current_account)
  end
end
