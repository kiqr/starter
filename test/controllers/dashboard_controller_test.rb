require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users to the sign-in page" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "allows authenticated users to access the dashboard" do
    sign_in create(:user)
    get dashboard_path

    assert_response :success
  end
end
