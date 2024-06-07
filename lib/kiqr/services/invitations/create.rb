module Kiqr
  module Services
    module Invitations
      class Create < Kiqr::ApplicationService
        def call(invitation:, user:)
          @invitation, @user = invitation, user

          invitation.transaction do
            invitation.save!
            # @todo: AccountMailer.invitation_email(invitation).deliver_later
          end

          success invitation
        end

        private

        attr_reader :invitation, :user
      end
    end
  end
end
