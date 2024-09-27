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

  test "renders the invitation token url" do
    @invitation = create(:member, :invitation, account: @account)
    get invitation_link_modal_account_settings_member_path(account_id: @account, id: @invitation)

    assert_response :success
  end

  test "prevents removal of the team owner (not yet implemented)" do
    @member = Member.find_by(account: @account, user: @user)
    delete account_settings_member_path(account_id: @account, id: @member)

    assert_equal I18n.t("flash_messages.account_owner_deletion_error"), flash[:alert]
    assert_redirected_to account_settings_members_path
  end

  test "removes a member from the team" do
    @member = create(:member, account: @account)
    delete account_settings_member_path(account_id: @account, id: @member)

    assert I18n.t("flash_messages.member_deleted")
    assert_redirected_to account_settings_members_path
  end

  test "user can leave the team" do
    another_account = create(:account)
    member = create(:member, user: @user, account: another_account, owner: false)

    delete account_settings_member_path(account_id: another_account, id: member)

    assert I18n.t("flash_messages.account_leaved", account_name: @account.name)
    assert_redirected_to dashboard_path(account_id: nil)
  end
end
