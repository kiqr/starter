module Kiqr
  module Services
    module Invitations
      class Accept < Kiqr::ApplicationService
        def call(invitation:, user:)
          @invitation, @user = invitation, user
          @account = @invitation.account

          raise Kiqr::Errors::InvitationExpiredError, "Invitation has already been used" if invitation.accepted_at?

          account.transaction do
            invitation.transaction do
              account.account_users.create!(user:)
              invitation.update!(accepted_at: Time.now)
            end
          end

          success invitation
        end

        private

        attr_reader :account, :invitation, :user
      end
    end
  end
end
