class Users::Auth::OnboardingController < ApplicationController
  layout "public"

  skip_before_action :ensure_onboarded
  before_action :setup_user

  before_action do
    # This is to prevent users from accessing the onboarding process
    # if they have already completed it. A user can only have one
    # personal account. If they have one, they have completed the
    # onboarding process.
    redirect_to dashboard_path if current_user.onboarded?

    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.onboarding"), onboarding_path
  end

  def show
    @user.build_personal_account(personal: true)
  end

  def update
    @user.assign_attributes(user_params)
    @user.personal_account.personal = true

    if @user.save
      kiqr_flash_message(:notice, :onboarding_completed)
      redirect_to after_onboarding_path(@user)
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def setup_user
    @user = User.find(current_user.id)
  end

  def user_params
    account_attributes = Rails.configuration.account_params.prepend(:id)
    params.require(:user).permit(:email, :time_zone, :locale, personal_account_attributes: account_attributes)
  end
end
