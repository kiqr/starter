require "test_helper"

class Kiqr::OnboardingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @onboarded_user = create(:user)
    @fresh_user = create(:user, personal_account: nil)
  end

  test "redirects to dashboard if user has already completed onboarding" do
    sign_in @onboarded_user
    get onboarding_path

    assert_redirected_to dashboard_path
  end

  test "displays onboarding form if user has not completed onboarding" do
    sign_in @fresh_user
    get onboarding_path

    assert_response :success
  end

  test "successfully completes user onboarding and redirects to dashboard" do
    sign_in @fresh_user
    patch onboarding_path, params: { user: { personal_account_attributes: { name: "Foobar zoo" } } }

    assert_redirected_to dashboard_path
    @fresh_user.reload

    assert @fresh_user.personal_account.personal?
    assert_equal "Foobar zoo", @fresh_user.personal_account.name
  end

  test "fails to onboard user with invalid data and re-renders form" do
    sign_in @fresh_user
    patch onboarding_path, params: { user: { personal_account_attributes: { name: "no" } } }

    assert_response :unprocessable_entity
    assert_template :show
  end
end
