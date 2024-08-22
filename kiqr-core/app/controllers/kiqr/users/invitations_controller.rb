class Kiqr::Users::InvitationsController < ApplicationController
  before_action :setup_member_and_account
  before_action :ensure_no_duplicate_users

  def show
    @invitation_token = @member.invitation_token
  end

  def accept_invitation
    @member.accept_invitation_for_user(current_user.id)
    kiqr_flash_message(:success, :accepted_invitation)
    redirect_to dashboard_path(account_id: @account)
  end

  def decline_invitation
    @member.decline_invitation
    kiqr_flash_message(:notice, :declined_invitation, account_name: @account.name)
    redirect_to dashboard_path
  end

  private
    # Set up the member and account for the invitation.
    def setup_member_and_account
      @member = Member.find_by_invitation_token(params[:token])
      @account = @member.account
    end

    # Ensure that the user is not already a member of the team.
    def ensure_no_duplicate_users
      return unless @account.users.include?(current_user)

      kiqr_flash_message(:danger, :already_member_of_team)
      redirect_to dashboard_path
    end

    # Ensure that the user is signed in before proceeding.
    def authenticate_user!
      return if user_signed_in?

      session[:after_sign_in_path] = user_invitation_path(token: params[:token], account_id: nil)
      kiqr_flash_message(:notice, :register_to_accept_invitation)
      redirect_to new_user_registration_path
    end

    # Ensure that the user has selected a team account before proceeding.
    def ensure_onboarded
      return if current_user.onboarded? # Check if user is not onboarded

      session[:after_sign_in_path] = user_invitation_path(token: params[:token], account_id: nil)
      kiqr_flash_message(:notice, :onboard_to_accept_invitation)
      redirect_to onboarding_path
    end
end
