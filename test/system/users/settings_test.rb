require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  test "can edit user and personal account" do
    user = create(:user)

    sign_in(user)
    visit edit_settings_path

    # Fill the personal account form
    select "Swedish", from: "user[locale]"
    fill_in "user[personal_account_attributes][name]", with: "New name"

    click_on "commit"
    assert_text I18n.t("kiqr.flash_messages.settings_updated")

    user.reload

    assert_current_path edit_settings_path
    assert_equal "New name", user.personal_account.name
    assert_equal "sv", user.locale
  end
end
