# The onboarding process is the process of creating a personal
# account for the user. The user must have a personal account
# before they can create any other type of account.
#
# A user is considered to have completed the
# onboarding process when they have a personal account.
class Users::OnboardingController < ApplicationController
  skip_before_action :ensure_onboarded

  before_action do
    # This is to prevent users from accessing the onboarding process
    # if they have already completed it. A user can only have one
    # personal account. If they have one, they have completed the
    # onboarding process.
    redirect_to dashboard_path if current_user.onboarded?

    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.onboarding"), onboarding_path
  end

  def new
    @user = User.find(current_user.id)
    @user.build_personal_account(personal: true)
  end

  def update
    @user = User.find(current_user.id)
    @user.assign_attributes(user_params)
    @user.personal_account&.personal = true

    if @user.valid?
      Kiqr::Services::Users::Update.call!(user: @user)
      kiqr_flash_message(:notice, :settings_updated)
      redirect_to after_onboarding_path(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    account_attributes = Kiqr.config.account_attributes.prepend(:id)
    params.require(:user).permit(:time_zone, :locale, personal_account_attributes: account_attributes)
  end
end
