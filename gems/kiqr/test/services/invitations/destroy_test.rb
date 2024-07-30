require "test_helper"

module Kiqr
  module Services
    module Invitations
      class DestroyTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Invitations::Destroy.new
        end

        test "destroys invitation" do
          account = create(:account)
          user = create(:user, with_account: account)
          invitation = create(:account_invitation, account: account)
          @service.call(invitation: invitation, user: user)

          assert_not AccountInvitation.find_by_id(invitation.id)
        end
      end
    end
  end
end
