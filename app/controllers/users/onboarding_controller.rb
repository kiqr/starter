class Users::OnboardingController < ApplicationController
  layout "public"

  skip_before_action :ensure_onboarded
  skip_before_action :redirect_with_account_parameter
  before_action :setup_onboarding_form, only: %i[show update]

  before_action do
    # This is to prevent users from accessing the onboarding process
    # if they have already completed it. A user can only have one
    # personal account. If they have one, they have completed the
    # onboarding process.
    redirect_to dashboard_path if current_user.onboarded?

    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.onboarding"), onboarding_path
  end

  def show; end

  def update
    if @form.update(onboarding_form_params)
      @form.persist if @form.final_step?
      # kiqr_flash_message(:notice, :onboarding_completed)
      redirect_to next_redirect_path
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def after_onboarding_path
    dashboard_path
  end

  def next_redirect_path
    @form.final_step? ? after_onboarding_path : onboarding_path(step: @form.next_step)
  end

  def onboarding_form_params
    params.require(:onboarding_form).permit(:toc_accepted, :name, :account_name, :locale, :time_zone)
  end

  def setup_onboarding_form
    user = User.find(current_user.id)
    user.build_profile if user.profile.blank?
    account = Account.new

    @form = OnboardingForm.new(session: session, step: params[:step], models: { user: user, profile: user.profile, account: account })
  end
end
