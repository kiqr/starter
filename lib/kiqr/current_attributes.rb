module Kiqr
  class CurrentAttributes < ActiveSupport::CurrentAttributes
    attribute :account, :user

    # Get the member record based on the current account and user.
    def member
      return unless account

      @member ||= account.members.includes(:user).find_by(user: user)
    end
  end
end
