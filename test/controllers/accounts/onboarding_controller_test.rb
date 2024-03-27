require "test_helper"

class Accounts::OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "redirects to dashboard_path if user is already onboarded" do
    sign_in create(:user)
    get accounts_onboarding_path
    assert_redirected_to dashboard_path
  end

  test "renders the onboarding form if user is not onboarded" do
    sign_in create(:user, personal_account: nil)
    get accounts_onboarding_path
    assert_response :success
  end
end
