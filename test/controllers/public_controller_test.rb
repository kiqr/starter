require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test "should get landing_page" do
    get public_landing_page_url
    assert_response :success
  end
end
