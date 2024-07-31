class Users::Settings::ApplicationController < ApplicationController
  renders_submenu partial: "users/settings/navigation"

  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.settings"), user_settings_profile_path
  end
end
