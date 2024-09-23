require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test "renders landing page for unauthenticated users" do
    get root_path
    assert_response :success
  end

  test "renders landing page for authenticated users" do
    sign_in create(:user)
    get root_path

    assert_response :success
  end
end
