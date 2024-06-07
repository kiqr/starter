require "test_helper"

class AccountUserTest < ActiveSupport::TestCase
  test "can't remove the team owner" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.account_users << AccountUser.create(user: user, owner: true)

    assert_raise Kiqr::Errors::DeleteTeamOwnerError do
      account.account_users.first.destroy!
    end
  end
end
