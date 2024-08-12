require "test_helper"

module Kiqr
  module Services
    module Teams
      class CreateTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Teams::Create.new
        end

        test "creates team account with ownership" do
          user = create(:user)
          team = build(:account)
          @service.call(account: team, user:)

          assert_not_empty team.members, "Expected members not to be empty"
          assert team.members.find_by(user: user).owner, "Expected members to have owner set to true"
          assert_not team.personal, "Expected personal to be false"
          assert team.persisted?, "Expected account to be saved"
        end

        test "account with invalid attributes raises error" do
          user = create(:user)
          assert_raises(StandardError) do
            @service.call(account: build(:account, name: "no"), user:)
          end
        end
      end
    end
  end
end
