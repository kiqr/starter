require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "can render edit page" do
    sign_in create(:user)
    get edit_account_path
    assert_response :success
  end

  test "can update personal accounts" do
    user = create(:user)
    sign_in user

    patch account_path, params: {account: {name: "New name"}}
    user.reload

    assert_redirected_to edit_account_path
    assert_equal "New name", user.personal_account.name
  end

  test "can update team accounts" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user:, role: "owner")

    sign_in user
    patch account_path(account_id: account), params: {account: {name: "New company name"}}
    account.reload

    assert_redirected_to edit_account_path
    assert_equal "New company name", account.name
  end

  test "re-renders form if form data is invalid" do
    user = create(:user)
    sign_in user

    patch account_path, params: {account: {name: "no"}}
    assert_response :unprocessable_entity
  end
end
