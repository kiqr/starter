require "test_helper"

class Kiqr::AccountsControllerTest < ActionDispatch::IntegrationTest
  test "redirect to profile edit if personal account" do
    sign_in create(:user)
    get edit_account_path
    assert_redirected_to edit_settings_path
  end

  test "can update team accounts" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user:, owner: true)

    sign_in user
    patch account_path(account_id: account), params: { account: { name: "New company name" } }
    account.reload

    assert_redirected_to edit_account_path
    assert_equal "New company name", account.name
  end

  test "re-renders form if form data is invalid" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user:, owner: true)

    sign_in user

    patch account_path(account_id: account), params: { account: { name: "no" } }
    assert_response :unprocessable_entity
  end
end
