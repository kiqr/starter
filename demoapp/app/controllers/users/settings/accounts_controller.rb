class Users::Settings::AccountsController < Users::Settings::ApplicationController
  before_action :setup_user, only: [ :index ]
  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.accounts"), user_settings_profile_path
  end

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

  def account_params
    params.require(:account).permit(Kiqr.config.account_attributes)
  end
end
