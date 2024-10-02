class Users::OnboardingController < ApplicationController
  layout "public"

  skip_before_action :ensure_onboarded
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
      # kiqr_flash_message(:notice, :onboarding_completed)
      redirect_to onboarding_path(step: @form.next_step)
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def onboarding_form_params
    params.require(:onboarding_form).permit(:toc_accepted, :full_name)
  end

  def setup_onboarding_form
    @form = OnboardingForm.new(session: session, step: params[:step])
  end
end
