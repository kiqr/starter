class Accounts::Settings::ProfilesController < Accounts::Settings::BaseController
  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.settings.accounts.profile.index"), account_settings_profile_path
  end

  def show
  end

  def update
    if @account.update(account_profile_params)
      kiqr_flash_message(:success, :account_profile_updated)
      redirect_to account_settings_profile_path
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def account_profile_params
    params.require(:account).permit(Rails.configuration.account_params)
  end
end
