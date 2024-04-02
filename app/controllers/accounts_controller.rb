class AccountsController < ApplicationController
  before_action :setup_account, only: %i[edit update]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_permitted_parameters)
    @account.account_users.new(user: current_user, role: "owner")

    if @account.save
      redirect_to dashboard_path(account_id: @account), notice: I18n.t("accounts.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_permitted_parameters)
      redirect_to edit_account_path, notice: I18n.t("accounts.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def setup_account
    @account = Account.find(current_account.id)
  end

  def form_submit_path
    @account.persisted? ? account_path : accounts_path
  end
  helper_method :form_submit_path

  def form_method
    @account.persisted? ? :patch : :post
  end
  helper_method :form_method
end
