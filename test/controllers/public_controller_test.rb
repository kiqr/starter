require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test "should show landing page" do
    get root_url
    assert_response :success
  end
end
