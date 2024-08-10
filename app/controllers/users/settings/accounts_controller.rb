class Users::Settings::AccountsController < Users::Settings::ApplicationController
  before_action :setup_user, only: [ :index ]
  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.accounts"), user_settings_profile_path
  end

  def index
    @accounts = current_user.accounts
  end
end
