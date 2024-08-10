class Accounts::Settings::ApplicationController < ApplicationController
  renders_submenu partial: "accounts/settings/navigation"

  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.root"), account_settings_profile_path
    add_breadcrumb current_account.name, account_settings_profile_path
  end

  private

  def setup_account
    @account = Account.find(current_account.id)
  end
end
