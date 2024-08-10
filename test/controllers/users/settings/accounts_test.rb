require "test_helper"

class Users::Settings::AccountsControllerTest < ActionDispatch::IntegrationTest
  test "can render accounts index" do
    sign_in create(:user, :with_accounts, accounts_count: 3)
    get user_settings_accounts_path

    assert_equal assigns(:memberships).count, 3
    assert_response :success
  end

  test "can render new account page" do
    sign_in create(:user)
    get new_user_settings_account_path
    assert_response :success
  end

  test "creates new account with ownership by user" do
    user = create(:user)
    sign_in user

    post user_settings_accounts_path, params: { account: { name: "Foobar team" } }
    new_team = Account.find_by(name: "Foobar team")

    assert_redirected_to dashboard_path(account_id: new_team)
    assert new_team.account_users.find_by(user: user).owner?
  end

  test "shows error on invalid team account creation" do
    user = create(:user)
    sign_in user

    post user_settings_accounts_path, params: { account: { name: "no" } }

    assert_response :unprocessable_content
    assert_template :new
  end
end
