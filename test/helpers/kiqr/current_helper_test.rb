require "test_helper"

class Kiqr::CurrentHelperTest < ActionView::TestCase
  attr_reader :current_user

  setup do
    @current_user = create(:user)
    @team_account = create(:account, name: "Company 1")
    @alien_account = create(:account, name: "Someone else's account")
    @current_user.account_users << AccountUser.new(account: @team_account, owner: true)

    Current.user = @current_user
  end

  test "current_account returns the personal account by default" do
    assert_equal @current_user.personal_account, current_account
  end

  test "current_account can be a team account" do
    Current.account = @team_account
    assert_equal @team_account, current_account
  end

  test "current_account can't be another users account" do
    assert_raise { Current.account = @alien_account }
  end

  test "personal_account is always the users personal account" do
    Current.account = @team_account
    assert_equal @current_user.personal_account, personal_account
  end
end
