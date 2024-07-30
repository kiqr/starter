class Kiqr::InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @invitation = AccountInvitation.find_puid!(params[:id])

    if @invitation.accepted_at?
      flash[:alert] = "Invitation has already been accepted by you or someone else."
      return redirect_to dashboard_path
    elsif @invitation.account.has_member?(current_user)
      flash[:notice] = "You are already a member of this team."
      return redirect_to dashboard_path(account_id: @invitation.account)
    end

    @team = @invitation.account
    session[:after_sign_in_path] = invitation_path(@invitation)
  end

  def accept
    @invite = AccountInvitation.find_puid!(params[:id])
    Kiqr::Services::Invitations::Accept.call!(invitation: @invite, user: current_user)
    kiqr_flash_message(:notice, :invitation_accepted, account: @invite.account.name)
    redirect_to dashboard_path(account_id: @invite.account)
  rescue Kiqr::Errors::InvitationExpiredError
    kiqr_flash_message(:alert, :invitation_expired)
    redirect_back(fallback_location: dashboard_path)
  end

  def reject
    @invitation = AccountInvitation.find_puid!(params[:id])
    Kiqr::Services::Invitations::Reject.call!(invitation: @invitation, user: current_user)
    kiqr_flash_message(:alert, :invitation_rejected, account: @invitation.account.name)
    redirect_to dashboard_path
  end
end
