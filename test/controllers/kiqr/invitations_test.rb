require "test_helper"

class Users::InvitationsTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account, :with_users, users_count: 2)
    @user = create(:user)
    @member = create(:member, account: @account, user: @user)
    @fresh_user = create(:user, personal_account: nil)
    @onboarded_user = create(:user)
    @invitation = create(:member, :invitation, account: @account, invited_by: @member)
  end

  test "redirects unauthenticated users to registration page and stores the invitation url in after_sign_in_path" do
    get user_invitation_path(token: @invitation.invitation_token)

    assert_equal I18n.t("flash_messages.register_to_accept_invitation"), flash[:notice]
    assert_equal user_invitation_path(token: @invitation.invitation_token, account_id: nil), session[:after_sign_in_path]
    assert_redirected_to new_user_registration_path
  end

  test "redirects non-onboarded users to onboarding page and stores the invitation url in after_sign_in_path" do
    sign_in(@fresh_user)
    get user_invitation_path(token: @invitation.invitation_token)

    assert_equal I18n.t("flash_messages.onboard_to_accept_invitation"), flash[:notice]
    assert_equal user_invitation_path(token: @invitation.invitation_token, account_id: nil), session[:after_sign_in_path]
    assert_redirected_to onboarding_path
  end

  test "prevents access to invitation if user is already a member of the team" do
    sign_in(@user)
    get user_invitation_path(token: @invitation.invitation_token)

    assert_equal I18n.t("flash_messages.already_member_of_team"), flash[:alert]
    assert_redirected_to dashboard_path
  end

  test "allows viewing the invitation if signed in and not yet a member of the team" do
    sign_in(@onboarded_user)
    get user_invitation_path(token: @invitation.invitation_token)

    assert_response :success
    assert_template "users/invitations/show"
  end

  test "allows accepting an invitation and redirects to the team dashboard" do
    sign_in(@onboarded_user)
    patch accept_user_invitation_path(token: @invitation.invitation_token)

    assert_redirected_to dashboard_path(account_id: @account)
    assert_equal I18n.t("flash_messages.accepted_invitation"), flash[:success]
    assert @onboarded_user.reload.accounts.include?(@account)
  end

  test "allows declining an invitation and removes the invitation from the database" do
    sign_in(@onboarded_user)
    delete decline_user_invitation_path(token: @invitation.invitation_token)

    assert_equal I18n.t("flash_messages.declined_invitation", account_name: @account.name), flash[:notice]
    assert_redirected_to dashboard_path
    assert_not Member.exists?(@invitation.id)
  end
end
