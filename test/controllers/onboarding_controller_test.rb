require "test_helper"

class Kiqr::OnboardingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fresh_user = create(:user, :nonboarded)
  end

  test "redirects to dashboard if user has already completed onboarding" do
    sign_in(create(:user))
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

    # Step: Terms and conditions
    post onboarding_path, params: { onboarding_form: { toc_accepted: "1" } }
    assert_redirected_to onboarding_path(step: :profile)

    # Step: Profile
    post onboarding_path(step: :profile), params: { onboarding_form: { name: "John Doe", account_name: "Foo Company Inc" } }
    assert_redirected_to dashboard_path

    @fresh_user.reload
    assert_equal "John Doe", @fresh_user.profile.name
    assert_equal 1, @fresh_user.accounts.count
    assert_equal "Foo Company Inc", @fresh_user.accounts.first.name
  end

  test "fails to onboard user with invalid data and re-renders form" do
    sign_in @fresh_user
    post onboarding_path(step: :profile), params: { onboarding_form: { name: "J", account_name: "Foo Company Inc" } }

    assert_response :unprocessable_entity
    assert_template :show
  end

  test "can create profile without account_name" do
    sign_in @fresh_user
    
    # Step: Terms and conditions
    post onboarding_path, params: { onboarding_form: { toc_accepted: "1" } }
    assert_redirected_to onboarding_path(step: :profile)

    # Step: Profile
    post onboarding_path(step: :profile), params: { onboarding_form: { name: "John Doe" } }
    assert_redirected_to dashboard_path
  end
end
