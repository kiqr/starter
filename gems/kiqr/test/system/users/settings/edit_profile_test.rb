require "application_system_test_case"

class EditProfileTest < ApplicationSystemTestCase
  test "can edit user and personal account" do
    user = create(:user)

    sign_in(user)
    visit user_settings_profile_path

    # Fill the personal account form
    select "Swedish", from: "user[locale]"
    fill_in "user[personal_account_attributes][name]", with: "New name"

    click_on I18n.t("kiqr.users.settings.profiles.show.submit")
    assert_text I18n.t("flash_messages.profile_updated")

    user.reload

    assert_current_path user_settings_profile_path
    assert_equal "New name", user.personal_account.name
    assert_equal "sv", user.locale
  rescue I18n::MissingTranslationData
  end

  test "can cancel pending email change" do
    user = create(:user)
    user.update(email: "this.email.is@pending.com")

    sign_in(user)
    visit user_settings_profile_path

    assert_text ActionView::Base.full_sanitizer.sanitize(I18n.t(
      "kiqr.users.settings.profiles.show.notifications.pending_email_change.text",
      email: "this.email.is@pending.com"
    ))

    click_on ActionView::Base.full_sanitizer.sanitize(I18n.t("kiqr.users.settings.profiles.show.notifications.pending_email_change.cancel"))
    assert_text I18n.t("flash_messages.email_change_pending_cancelled")
    assert_current_path user_settings_profile_path
  end
end
