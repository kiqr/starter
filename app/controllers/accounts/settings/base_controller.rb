class Accounts::Settings::BaseController < ApplicationController
  before_action :ensure_team_account
  before_action :setup_account

  renders_submenu partial: "accounts/settings/navigation"

  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.root"), account_settings_profile_path
  end

  private

  def setup_account
    @account = Account.find(current_account.id)
  end
end
