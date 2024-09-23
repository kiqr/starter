require "application_system_test_case"

class TwoFactorTest < ApplicationSystemTestCase
  def prepare_otp_setup(user)
    sign_in user
    visit user_settings_two_factor_path
    assert_selector "a.irelia-button", text: I18n.t("kiqr.users.settings.two_factor.show.buttons.enable")

    pre_otp_secret = user.otp_secret

    click_link I18n.t("kiqr.users.settings.two_factor.show.buttons.enable")
    assert_current_path new_user_settings_two_factor_path
    assert_not user.otp_required_for_login?

    # Check that a new secret was generated
    assert_not_equal pre_otp_secret, user.reload.otp_secret
  end

  test "Can enable otp secret" do
    user = create(:user)
    prepare_otp_setup(user)

    # Fill in code field with the correct code
    fill_in "user[otp_attempt]", with: user.current_otp
    click_button I18n.t("kiqr.users.settings.two_factor.form.verify_button")

    assert_current_path user_settings_two_factor_path
    assert user.reload.otp_required_for_login?
    assert_text I18n.t("flash_messages.two_factor_enabled")
  end

  test "Show error message if otp code is wrong" do
    user = create(:user)
    prepare_otp_setup(user)

    # Fill in code field with an invalid code
    fill_in "user[otp_attempt]", with: "123456"
    click_button I18n.t("kiqr.users.settings.two_factor.form.verify_button")

    assert_current_path new_user_settings_two_factor_path
    assert_not user.reload.otp_required_for_login?
    assert_text I18n.t("kiqr.users.settings.two_factor.form.invalid_otp")
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
    visit user_settings_two_factor_path
    assert_selector ".irelia-button", text: I18n.t("kiqr.users.settings.two_factor.show.buttons.disable")
  end

  test "can disable two factor authentication" do
    user = create(:user, :otp_enabled)
    sign_in user
    visit user_settings_two_factor_path
    fill_in "user[otp_attempt]", with: user.current_otp
    find(".irelia-form button[type='submit']").click

    assert_text I18n.t("flash_messages.two_factor_disabled")
    assert_not user.reload.otp_required_for_login?
  end

  test "can't disable two factor authentication with wrong otp code" do
    user = create(:user, :otp_enabled)
    sign_in user
    visit user_settings_two_factor_path
    fill_in "user[otp_attempt]", with: "12345"
    find(".irelia-form button[type='submit']").click

    assert_text I18n.t("kiqr.users.settings.two_factor.form.invalid_otp")
    assert user.reload.otp_required_for_login?
  end
end
