require "test_helper"

class Kiqr::OnboardingControllerTest < ActionDispatch::IntegrationTest
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
    user = create(:user, personal_account: nil)
    sign_in user
    post onboarding_path, params: {user: {personal_account_attributes: {name: "Foobar zoo"}}}
    assert_redirected_to dashboard_path
    assert user.reload.personal_account.personal?
  end

  test "validates user onboarding" do
    sign_in create(:user, personal_account: nil)
    post onboarding_path, params: {user: {personal_account_attributes: {name: "no"}}}
    assert_response :unprocessable_entity
    assert_template :new
  end
end
