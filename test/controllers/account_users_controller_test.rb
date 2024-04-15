require "test_helper"

class AccountUsersControllerTest < ActionDispatch::IntegrationTest
  test "can't show members as personal account" do
    user = create(:user)
    sign_in user
    get account_users_path

    assert_redirected_to edit_account_path(account_id: nil)
  end

  test "can show edit member page" do
    user = create(:user)
    some_user = create(:user)

    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user: user, owner: true)
    account.account_users << AccountUser.create(user: some_user)

    sign_in user
    get edit_account_user_path(account_id: account, id: some_user.account_users.first)

    assert_response :success
  end

  test "can show members as team account" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user:, owner: true)

    sign_in user
    get account_users_path(account_id: account)

    assert_response :success
  end

  test "can remove a member from team" do
    user = create(:user)
    some_user = create(:user)

    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user: user, owner: true)
    account.account_users << AccountUser.create(user: some_user)

    assert_includes account.reload.users, some_user

    sign_in user
    delete account_user_path(account_id: account, id: some_user.account_users.first)

    assert_redirected_to account_users_path(account_id: account)
    assert_not_includes account.reload.users, some_user
  end

  test "can not remove the team owner" do
    skip "This test is not implemented yet"
  end
end
