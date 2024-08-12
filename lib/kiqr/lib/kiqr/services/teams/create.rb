module Kiqr
  module Services
    module Teams
      # Create account service
      # User can create a personal account or a team account.
      # User can have only one personal account.
      # User can be part of multiple team accounts.
      class Create < Kiqr::ApplicationService
        def call(account:, user:)
          @account, @user = account, user

          account.members.new(user: user, owner: true)
          account.save!

          success account
        end

        private

        attr_reader :account, :user
      end
    end
  end
end
