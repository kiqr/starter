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

  test "redirects to registrations path with invitation token stored in session if not signed in" do
    get user_invitation_path(token: @invitation.invitation_token)
    assert_equal I18n.t("flash_messages.register_to_accept_invitation"), flash[:notice]
    assert_equal user_invitation_path(token: @invitation.invitation_token, account_id: nil), session[:after_sign_in_path]
    assert_redirected_to new_user_registration_path
  end

  test "redirects to onboarding path with invitation token stored in session if not onboarded" do
    sign_in(@fresh_user)
    get user_invitation_path(token: @invitation.invitation_token)
    assert_equal I18n.t("flash_messages.onboard_to_accept_invitation"), flash[:notice]
    assert_equal user_invitation_path(token: @invitation.invitation_token, account_id: nil), session[:after_sign_in_path]
    assert_redirected_to user_onboarding_path
  end

  test "can't view an invitation if already member of team" do
    sign_in(@user)
    get user_invitation_path(token: @invitation.invitation_token)
    assert_equal I18n.t("flash_messages.already_member_of_team"), flash[:danger]
    assert_redirected_to dashboard_path
  end

  test "can view invitation if signed in and not a member of team" do
    sign_in(@onboarded_user)
    get user_invitation_path(token: @invitation.invitation_token)
    assert_response :success
    assert_template "users/invitations/show"
  end

  test "can accept an invitation" do
    sign_in(@onboarded_user)
    patch accept_user_invitation_path(token: @invitation.invitation_token)
    assert_redirected_to dashboard_path(account_id: @account)
    assert_equal I18n.t("flash_messages.accepted_invitation"), flash[:success]
    assert @onboarded_user.reload.accounts.include?(@account)
  end

  test "can decline an invitation" do
    sign_in(@onboarded_user)
    delete decline_user_invitation_path(token: @invitation.invitation_token)
    assert_equal I18n.t("flash_messages.declined_invitation", account_name: @account.name), flash[:notice]
    assert_redirected_to dashboard_path
    assert_not Member.exists?(@invitation.id)
  end
end
