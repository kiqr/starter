module Kiqr
  class AccountUsersController < KiqrController
    before_action :ensure_team_account
    before_action :setup_account

    def edit
      @account_user = @account.account_users.find_puid!(params[:id])
    end

    def destroy
      @account_user = @account.account_users.find_puid!(params[:id])
      @account_user.destroy!
      kiqr_flash_message(:alert, :account_user_destroyed)
      flash[:notice] = I18n.t("kiqr.flash_messages")
      redirect_to account_users_path
    end

    private

    def ensure_team_account
      redirect_to edit_account_path if current_account.personal?
    end

    def setup_account
      @account = current_account
      @members = current_account.account_users
    end
  end
end
