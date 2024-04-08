class Users::InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @invitation = AccountInvitation.find_puid!(params[:id])

    if @invitation.accepted_at?
      flash[:alert] = "Invitation has already been accepted by you or someone else."
      return redirect_to dashboard_path
    elsif current_user&.accounts&.include? @invitation.account
      flash[:notice] = "You are already a member of this team."
      return redirect_to dashboard_path(account_id: @invitation.account)
    end

    @team = @invitation.account
    session[:after_sign_in_path] = user_invitation_path(@invitation)
  end

  def update
    return redirect_back(fallback_location: dashboard_path) unless params[:user_invitation][:status] == "accepted"
    return head :forbidden if AccountInvitation.find_puid!(params[:id]).accepted_at?

    @invitation = AccountInvitation.find_puid!(params[:id])
    @account = @invitation.account
    @account.account_users.new(user: current_user)

    if @account.save
      @invitation.update(accepted_at: Time.now)
      flash[:notice] = "You have successfully joined the team"
      redirect_to dashboard_path(account_id: @account)
    else
      redirect_to user_invitation_path(@invitation), alert: "Failed to accept invitation. Please try again later"
    end
  end

  def destroy
    @invitation = AccountInvitation.find_puid!(params[:id])
    @invitation.destroy

    flash[:notice] = "You have declined the invitation"
    redirect_to dashboard_path
  end
end
