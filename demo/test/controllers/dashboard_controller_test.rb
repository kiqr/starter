require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect unauthenticated users to sign in form" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "should allow authenticated users to visit" do
    sign_in create(:user)
    get dashboard_path
    assert_response :success
  end
end
