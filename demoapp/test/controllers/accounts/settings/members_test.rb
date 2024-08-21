require "test_helper"

class Accounts::Settings::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account, :with_users, users_count: 2)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "renders members index page with correct members listed" do
    get account_settings_members_path(account_id: @account)

    assert_response :success
    assert_equal 3, assigns(:members).count
    assert_equal @user, assigns(:members).first.user
  end

  test "user cannot access another account's members index" do
    other_account = create(:account)
    get account_settings_members_path(account_id: other_account)

    assert_response :forbidden
  end

  test "raises error when attempting to access members index without account" do
    assert_raises(ActionController::UrlGenerationError) do
      get account_settings_members_path
    end
  end

  test "successfully creates a new member and redirects to members index" do
    assert_difference "@account.members.count", 1 do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foo@zoo.com" } }
    end

    assert_redirected_to account_settings_members_path(account_id: @account)
    assert_equal 4, @account.members.count
    assert_equal 3, @account.members.accepted.count
    assert_equal 1, @account.members.pending.count
  end

  test "does not create a new member when invitation email is invalid" do
    assert_no_difference "@account.members.count" do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "invalid_email" } }
    end

    assert_response :unprocessable_content
  end

  test "users can not invite a user to another account" do
    other_account = create(:account)
    post account_settings_members_path(account_id: other_account), params: { member: { invitation_email: "foobar@agag.com" } }

    assert_response :forbidden
  end

  test "does not allow inviting the same email address more than once" do
    post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foobar@foobar.com" } }

    assert_redirected_to account_settings_members_path(account_id: @account)

    assert_no_difference "@account.members.count" do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foobar@foobar.com" } }
    end
  end

  test "prevents removal of the team owner (not yet implemented)" do
    skip "Test for preventing the removal of the team owner is not implemented yet"
  end

  test "removes a member from the team (not yet implemented)" do
    skip "Test for removing a member from the team is not implemented yet"
  end
end
