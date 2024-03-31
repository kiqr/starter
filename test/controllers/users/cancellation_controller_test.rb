require "test_helper"

class Users::RegistrationControllerTest < ActionDispatch::IntegrationTest
  test "can delete a user without teams" do
    user = create(:user)
    sign_in user
    delete user_registration_path

    assert_redirected_to root_path
    assert_nil User.find_by(id: user.id)
  end

  test "can't delete a user with owned teams" do
    user = create(:user)
    team_account = create(:account, name: "Team account")
    team_account.account_users << AccountUser.create(user: user, role: "owner")

    sign_in user
    delete user_registration_path

    assert_redirected_to delete_user_registration_path
    assert User.find_by(id: user.id)
  end
end
