class AccountsController < ApplicationController
  before_action :setup_account, only: %i[edit update]

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to edit_account_path, notice: I18n.t("accounts.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def setup_account
    @account = Account.find(current_account.id)
  end
end
