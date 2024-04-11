module Kiqr
  module Services
    module Invitations
      class Destroy < Kiqr::ApplicationService
        def call(invitation:, user:)
          @invitation, @user = invitation, user

          invitation.transaction do
            invitation.destroy!
          end

          success invitation
        end

        private

        attr_reader :invitation, :user
      end
    end
  end
end
