class Users::InvitationsController < ApplicationController
  def show
    @member = Member.find_by_invitation_token(params[:token])
    @account = @member.account
  end

  def accept_invitation
  end

  def decline_invitation
  end
end
