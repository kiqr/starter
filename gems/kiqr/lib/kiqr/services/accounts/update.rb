module Kiqr
  module Services
    module Accounts
      class Update < Kiqr::ApplicationService
        def call(account:, user:)
          @account, @user = account, user

          permission_check
          account.save!

          success account
        end

        private

        # Check if user has permission to edit the account
        # User can edit their personal account or if they are part of the team.
        def permission_check
          return if user.personal_account == account || account.account_users.find_by(user: user)
          raise StandardError, "User does not have permission to edit this account"
        end

        attr_reader :account, :user
      end
    end
  end
end
