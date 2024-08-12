class Accounts::Settings::MembersController < Accounts::Settings::ApplicationController
  before_action :setup_account, only: [ :index ]
  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.settings.account_users"), account_settings_members_path
  end

  def index
    @memberships = @account.account_users.includes(:user).references(:user)
  end
end
