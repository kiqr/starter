require "test_helper"

class Users::OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "redirects to dashboard_path if user is already onboarded" do
    sign_in create(:user)
    get onboarding_path
    assert_redirected_to dashboard_path
  end

  test "renders the onboarding form if user is not onboarded" do
    sign_in create(:user, personal_account: nil)
    get onboarding_path
    assert_response :success
  end

  test "can onboard user" do
    sign_in create(:user, personal_account: nil)
    post onboarding_path, params: {account: {name: "Personal Account"}}
    assert_redirected_to dashboard_path
  end

  test "validates user onboarding" do
    sign_in create(:user, personal_account: nil)
    post onboarding_path, params: {account: {name: "no"}}
    assert_response :unprocessable_entity
    assert_template :new
  end
end
