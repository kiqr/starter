class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user

  def user=(user)
    super
    self.account = user&.personal_account if user&.onboarded?
  end

  def account=(account)
    raise "Account must be owned by the current user" unless user.accounts.include?(account) || account == user.personal_account
    super
  end
end
