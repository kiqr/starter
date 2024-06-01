require "test_helper"

module Kiqr
  module Services
    module Teams
      class UpdateTest < ActionDispatch::IntegrationTest
        def setup
          @service = Kiqr::Services::Teams::Update.new
        end

        test "can't update personal account" do
          personal_account = create(:account, personal: true)
          user = create(:user, personal_account: personal_account)

          assert_raises(StandardError) do
            @service.call(account: personal_account, user: user)
          end
        end

        test "updates team account" do
          team = create(:account)
          user = create(:user, with_account: team)
          team.assign_attributes(name: "New Team Name")

          @service.call(account: team, user: user)
          assert_equal "New Team Name", team.reload.name, "Expected account name to be updated"
        end

        test "account with invalid attributes raises error" do
          user = create(:user)
          alien_team = create(:account)
          alien_team.assign_attributes(name: "no")

          assert_raises(StandardError) do
            @service.call(account: alien_team, user: user)
          end
        end
      end
    end
  end
end
