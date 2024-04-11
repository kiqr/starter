require "test_helper"

module Kiqr
  module Services
    module Invitations
      class CreateTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Invitations::Create.new
        end

        test "creates invitation" do
          account = create(:account)
          user = create(:user, with_account: account)
          invitation = account.account_invitations.new(email: "foobar@zoo.com")
          @service.call(invitation: invitation, user: user)

          assert invitation.persisted?, "Expected invitation to be saved"
          assert_equal invitation.account, account, "Expected invitation to be associated with account"
          assert account.account_invitations.find_by(email: "foobar@zoo.com"), "Expected to find an invitation with the specified email"
        end

        test "invitation with invalid attributes raises error" do
          account = create(:account)
          user = create(:user, with_account: account)
          invitation = account.account_invitations.new(email: "foobar")

          assert_raises StandardError do
            @service.call(invitation: invitation, user: user)
          end
        end
      end
    end
  end
end
