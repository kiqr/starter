require "test_helper"

module Kiqr
  module Services
    module Accounts
      class UpdateTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Accounts::Update.new
        end

        test "updates personal account" do
          user = create(:user)
          account = user.personal_account
          account.assign_attributes(name: "New Name")

          @service.call(account: account, user: user)
          assert_equal "New Name", account.reload.name, "Expected account name to be updated"
        end

        test "updates team account" do
          account = create(:account)
          user = create(:user, with_account: account)
          account.assign_attributes(name: "New Team Name")

          @service.call(account: account, user: user)
          assert_equal "New Team Name", account.reload.name, "Expected account name to be updated"
        end

        test "account with invalid attributes raises error" do
          user = create(:user)
          alien_account = create(:account)
          alien_account.assign_attributes(name: "no")

          assert_raises(StandardError) do
            @service.call(account: alien_account, user: user)
          end
        end
      end
    end
  end
end
