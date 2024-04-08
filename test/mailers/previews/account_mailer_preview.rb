# Preview all emails at http://localhost:3000/rails/mailers/kiqr/account_mailer
class AccountMailerPreview < ActionMailer::Preview
  def invitation_email
    AccountMailer.invitation_email(AccountInvitation.first)
  end
end
