require "test_helper"

class Users::OnboardingTest < ActionDispatch::IntegrationTest
  test "redirects to dashboard_path if user is already onboarded" do
    sign_in create(:user)
    get user_onboarding_path
    assert_redirected_to dashboard_path
  end

  test "renders the onboarding form if user is not onboarded" do
    sign_in create(:user, personal_account: nil)
    get user_onboarding_path
    assert_response :success
  end

  test "can onboard user" do
    user = create(:user, personal_account: nil)
    sign_in user
    patch user_onboarding_path, params: { user: { personal_account_attributes: { name: "Foobar zoo" } } }
    assert_redirected_to dashboard_path
    user.reload

    assert user.personal_account.personal?
    assert_equal "Foobar zoo", user.personal_account.name
  end

  test "validates user onboarding" do
    sign_in create(:user, personal_account: nil)
    patch user_onboarding_path, params: { user: { personal_account_attributes: { name: "no" } } }
    assert_response :unprocessable_entity
    assert_template :new
  end
end
