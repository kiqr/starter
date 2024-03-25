class OnboardingController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :redirect_to_onboarding
  before_action :prevent_duplicate_personal_accounts

  def new
    @account = current_user.build_personal_account
  end

  def create
    @account = current_user.build_personal_account(account_params)
    @account.personal = true

    if current_user.save
      redirect_to after_onboarding_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  # This is to prevent users from accessing the onboarding process
  # if they have already completed it. A user can only have one
  # personal account. If they have one, they have completed the
  # onboarding process.
  def prevent_duplicate_personal_accounts
    redirect_to after_onboarding_path if current_user.onboarded?
  end

  # This is the path to redirect to after the onboarding process
  # is completed. By default, it redirects to the dashboard.
  def after_onboarding_path
    dashboard_path
  end
end