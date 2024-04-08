class Accounts::InvitationsController < ApplicationController
  def index
    @invitations = current_account.account_invitations.pending
    @account = current_account
  end

  def new
    @invitation = current_account.account_invitations.new
  end

  def create
    @invitation = current_account.account_invitations.new(invitation_params)
    if @invitation.save
      # AccountMailer.invitation_email(@invitation).deliver_later
      redirect_to invitations_path(account_id: current_account), notice: t(".invitation_sent", email: @invitation.email)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @invitation = current_account.account_invitations.find_puid!(params[:id])
    @invitation.destroy
    redirect_to invitations_path, notice: t(".deleted")
  end

  private

  def invitation_params
    params.require(:account_invitation).permit(:email)
  end
end
