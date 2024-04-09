module Kiqr
  module Services
    module Accounts
      class Create < Kiqr::ApplicationService
        def call(account:, user:, personal: false)
          @account, @user = account, user

          personal ? create_personal_account : create_team_account

          success account
        end

        private

        def create_personal_account
          raise StandardError, "User already has a personal account" if user.personal_account.present?

          user.transaction do
            account.personal = true
            user.personal_account = account
            user.save!
          end
        end

        def create_team_account
          account.transaction do
            account.account_users.new(user: user, owner: true)
            account.save!
          end
        end

        private

        attr_reader :account, :user
      end
    end
  end
end
