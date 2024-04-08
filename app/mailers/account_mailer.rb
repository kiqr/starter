class AccountMailer < ApplicationMailer
  def invitation_email(invitation)
    @invitation = invitation
    @account = invitation.account
    mail to: invitation.email, subject: t(".subject", team_name: @account.name)
  end
end
