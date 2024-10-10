require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users to the sign-in page" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "allows authenticated users to access the dashboard" do 
    user = create(:user)
    sign_in user 
    get dashboard_path

    assert_redirected_to dashboard_path(account_id: user.accounts.first.public_uid)
    follow_redirect!
    assert_response :success
  end
end
