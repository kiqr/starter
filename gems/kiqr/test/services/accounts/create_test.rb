require "test_helper"

module Kiqr
  module Services
    module Accounts
      class CreateTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Accounts::Create.new
        end

        test "creates team account" do
          user = create(:user)
          account = build(:account)
          @service.call(account:, user:, personal: false)

          refute_empty account.account_users, "Expected account_users not to be empty"
          assert account.account_users.find_by(user: user).owner, "Expected account_users to have owner set to true"
          refute account.personal, "Expected account.personal to be false"
          assert account.persisted?, "Expected account to be saved"
        end

        test "creates personal account" do
          user = create(:user, personal_account: nil)
          account = build(:account)
          @service.call(account:, user:, personal: true)

          assert_empty account.account_users, "Expected account_users to be empty"
          assert account.personal, "Expected account.personal to be true"
          assert_equal account, user.personal_account, "Expected user to have personal account"
        end

        test "can only have one personal account" do
          user = create(:user)
          assert_raises(StandardError) do
            @service.call(account: Account.new(name: "Jane Doe"), user:, personal: true)
          end
        end

        test "account with invalid attributes raises error" do
          user = create(:user)
          assert_raises(StandardError) do
            @service.call(account: build(:account, name: "no"), user:, personal: false)
          end
        end
      end
    end
  end
end
