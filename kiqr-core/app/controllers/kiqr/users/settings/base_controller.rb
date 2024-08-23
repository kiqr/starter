class Kiqr::Users::Settings::BaseController < ApplicationController
  renders_submenu partial: "kiqr/users/settings/navigation"

  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("kiqr.breadcrumbs.settings.root"), user_settings_profile_path
  end

  private

  def setup_user
    @user = User.find(current_user.id)
  end
end
