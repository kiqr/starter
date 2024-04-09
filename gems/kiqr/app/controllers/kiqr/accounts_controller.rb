module Kiqr
  class AccountsController < ApplicationController
    before_action :setup_account, only: %i[edit update]

    def new
      @account = Account.new
    end

    def create
      @account = Account.new(account_permitted_parameters)

      if @account.valid?
        Kiqr::Services::Accounts::Create.call!(account: @account, user: current_user)
        flash[:notice] = I18n.t("accounts.create.success")
        redirect_to dashboard_path(account_id: @account)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @account.assign_attributes(account_permitted_parameters)

      if @account.valid?
        Kiqr::Services::Accounts::Update.call!(account: @account, user: current_user)
        flash[:notice] = I18n.t("accounts.update.success")
        redirect_to edit_account_path
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
end
