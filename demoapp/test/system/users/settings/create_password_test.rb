require "application_system_test_case"

class CreatePasswordTest < ApplicationSystemTestCase
  test "can add password to account" do
    user = create(:user, :without_password)

    sign_in(user)
    visit user_settings_password_path

    # Shouldn't be any current_password field.
    assert_no_field "user[current_password]"

    # Fill the password form
    fill_in "user[password]", with: "newpassword123"
    fill_in "user[password_confirmation]", with: "newpassword123"

    click_on I18n.t("users.settings.passwords.new.submit")
    assert_text I18n.t("flash_messages.password_created")

    user.reload

    assert_current_path user_settings_password_path
    assert user.valid_password?("newpassword123")
  end

  test "can update password" do
    user = create(:user)

    sign_in(user)
    visit user_settings_password_path

    fill_in "user[current_password]", with: "th1s1sp4ssw0rd"
    fill_in "user[password]", with: "newpassword123"
    fill_in "user[password_confirmation]", with: "newpassword123"

    find(".irelia-form button[type='submit']").click
    assert_text I18n.t("flash_messages.password_updated")

    user.reload

    assert_current_path user_settings_password_path
    assert user.valid_password?("newpassword123")
  end

  test "fails with invalid current password" do
    user = create(:user)

    sign_in(user)
    visit user_settings_password_path

    fill_in "user[current_password]", with: "invalid"
    fill_in "user[password]", with: "newpassword123"
    fill_in "user[password_confirmation]", with: "newpassword123"

    find(".irelia-form button[type='submit']").click
    assert_selector "#user_current_password_group", text: I18n.t("errors.messages.invalid")
  end
end
