class Kiqr::Users::Settings::AccountsController < Kiqr::Users::Settings::BaseController
  before_action :setup_user, only: [ :index ]
  before_action :setup_breadcrumbs

  def index
    @memberships = current_user.members.includes(:account).references(:account)
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    # Link the current user to the account as the owner
    @account.members.new(user: current_user, owner: true)

    if @account.save
      kiqr_flash_message :success, :account_created
      redirect_to dashboard_path(account_id: @account)
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def setup_breadcrumbs
    add_breadcrumb I18n.t("kiqr.breadcrumbs.settings.users.accounts.root"), user_settings_profile_path
    add_breadcrumb I18n.t("kiqr.breadcrumbs.settings.users.accounts.new"), user_settings_profile_path if %w[new create].include?(action_name)
  end

  def account_params
    params.require(:account).permit(Kiqr.config.account_attributes)
  end
end
