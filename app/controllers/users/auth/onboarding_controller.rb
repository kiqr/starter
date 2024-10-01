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
  end

  def update
    render json: params
    # if @user.update(user_params)
    #   kiqr_flash_message(:notice, :onboarding_completed)
    #   redirect_to after_onboarding_path(@user)
    # else
    #   render :show, status: :unprocessable_entity
    # end
  end

  private

  # def setup_user
  #   @user = User.find(current_user.id)
  # end

  # def user_params
  #   profile_attributes = Rails.configuration.profile_params.prepend(:id)
  #   params.require(:user).permit(:email, :time_zone, :locale, profile_attributes: profile_attributes)
  # end
end
