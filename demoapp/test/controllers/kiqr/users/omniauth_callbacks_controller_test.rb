require "test_helper"

class Kiqr::Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  include Kiqr::UrlHelper

  test "creates account if an account with the email does not exist" do
    post user_developer_omniauth_callback_path, params: { email: "john.doe@example.com" }

    assert User.find_by(email: "john.doe@example.com").present?
    assert_equal flash[:notice], I18n.t("flash_messages.signed_up_but_unconfirmed")
  end

  test "shows message if account with the current email already exists" do
    user = create(:user)
    post user_developer_omniauth_callback_path, params: { email: user.email }

    assert_equal flash[:alert], I18n.t("flash_messages.omniauth_email_taken", provider: "developer")
  end

  test "can login with an already existing connection" do
    omniauth_identity = create(:omniauth_identity)
    post user_developer_omniauth_callback_path, params: { email: omniauth_identity.provider_uid }

    assert_redirected_to after_sign_in_path_for(omniauth_identity.user)
  end

  test "prompts for OTP if two-factor authentication is enabled" do
    omniauth_identity = create(:omniauth_identity, user: create(:user, :otp_enabled))
    post user_developer_omniauth_callback_path, params: { email: omniauth_identity.provider_uid }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/otp"
  end

  test "signs in with otp if two-factor authentication is enabled" do
    omniauth_identity = create(:omniauth_identity, user: create(:user, :otp_enabled))
    user = omniauth_identity.user
    post user_developer_omniauth_callback_path, params: { email: omniauth_identity.provider_uid }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/otp"

    post user_session_path, params: { user: { otp_attempt: user.current_otp } }

    assert_redirected_to dashboard_path
  end

  test "fails to sign in with incorrect OTP when two-factor authentication is enabled" do
    omniauth_identity = create(:omniauth_identity, user: create(:user, :otp_enabled))
    user = omniauth_identity.user
    post user_developer_omniauth_callback_path, params: { email: omniauth_identity.provider_uid }
    post user_session_path, params: { user: { otp_attempt: "123456" } }

    assert_response :unprocessable_content
    assert_template "kiqr/sessions/otp"
  end

  test "allows linking multiple omniauth accounts" do
    first_omniauth_identity = create(:omniauth_identity)
    sign_in first_omniauth_identity.user

    assert_changes -> { first_omniauth_identity.user.omniauth_identities.count }, from: 1, to: 2 do
      post user_developer_omniauth_callback_path, params: { email: "new-identity@example.com" }
    end
  end

  test "fails to link an omniauth account it's already linked to another user" do
    conflicting_omniauth_identity = create(:omniauth_identity)
    user = create(:user)
    sign_in user

    assert_no_changes -> { create(:omniauth_identity).user.omniauth_identities.count } do
      post user_developer_omniauth_callback_path, params: { email: conflicting_omniauth_identity.provider_uid }
    end

    assert_equal flash[:alert], I18n.t("flash_messages.omniauth_identity_taken", provider: "developer")
  end
end
