require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test "should get landing_page" do
    get root_path
    assert_response :success
  end
end
