module Kiqr
  module Services
    module Teams
      # Update account service
      # User can update their personal account or if they are part of the team.
      class Update < Kiqr::ApplicationService
        def call(account:, user:)
          raise StandardError, "Account is not a team" unless account.team?

          @account, @user = account, user

          permission_check
          account.save!

          success account
        end

        private

        # Check if user has permission to edit the account
        # User can edit their personal account or if they are part of the team.
        def permission_check
          return if account.members.find_by(user: user)
          raise StandardError, "User does not have permission to edit this account"
        end

        attr_reader :account, :user
      end
    end
  end
end
