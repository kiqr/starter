require "application_system_test_case"

class TwoFactorTest < ApplicationSystemTestCase
  def prepare_otp_setup(user)
    sign_in user
    visit edit_two_factor_path
    assert_selector "a.button", text: I18n.t("users.two_factor.show.enable.button")

    pre_otp_secret = user.otp_secret

    click_link I18n.t("users.two_factor.show.enable.button")
    assert_current_path setup_two_factor_path
    assert_not user.otp_required_for_login?

    # Check that a new secret was generated
    assert_not_equal pre_otp_secret, user.reload.otp_secret
  end

  test "Can enable otp secret" do
    user = create(:user)
    prepare_otp_setup(user)

    # Fill in code field with the correct code
    fill_in "user[otp_attempt]", with: user.current_otp
    click_button "commit"

    assert_current_path edit_two_factor_path
    assert user.reload.otp_required_for_login?
    assert_text I18n.t("users.two_factor.setup.success")
  end

  test "Show error message if otp code is wrong" do
    user = create(:user)
    prepare_otp_setup(user)

    # Fill in code field with an invalid code
    fill_in "user[otp_attempt]", with: "123456"
    click_button "commit"

    assert_current_path setup_two_factor_path
    assert_not user.reload.otp_required_for_login?
    assert_text I18n.t("users.two_factor.setup.invalid_code")
  end

  test "refreshes qr code image on new setup" do
    user = create(:user)
    prepare_otp_setup(user)
    first_image = find("#qr-code-wrapper svg")
    prepare_otp_setup(user)
    second_image = find("#qr-code-wrapper svg")

    assert_not_equal first_image, second_image
  end

  test "shows instructions on how to disable two factor authentication" do
    user = create(:user, :otp_enabled)
    sign_in user
    visit edit_two_factor_path
    assert_selector "a.button", text: I18n.t("users.two_factor.show.disable.button")
  end
end
