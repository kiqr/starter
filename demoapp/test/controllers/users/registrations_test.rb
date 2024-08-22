require "test_helper"

class Users::RegistrationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user_with_team = create(:user, with_account: create(:account))
  end

  test "displays account cancellation page for signed-in user" do
    sign_in @user
    get delete_user_registration_path

    assert_response :success
  end

  test "deletes user account if user has no teams and redirects to home page" do
    sign_in @user
    delete user_registration_path

    assert_redirected_to root_path
    assert_nil User.find_by(id: @user.id)
  end

  test "prevents user account deletion if user owns teams and redirects to cancellation page" do
    sign_in @user_with_team
    delete user_registration_path

    assert_redirected_to delete_user_registration_path
    assert User.find_by(id: @user_with_team.id)
  end
end
