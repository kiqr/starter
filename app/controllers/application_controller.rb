class ApplicationController < ActionController::Base
  include SetCurrentAttributes
  include CurrentHelper

  before_action :authenticate_user!
  before_action :ensure_onboarded, unless: :devise_controller?

  private

  # Strong parameters for account.
  # Used for account creation and update.
  def account_params
    params.require(:account).permit(:name)
  end

  # Automatically include account_id in all URL options if it is already present in the params.
  # This is used to ensure that all routes are scoped to the current team. Personal account
  # routes are not affected.
  def default_url_options
    {account_id: params[:account_id]}
  end

  # Redirect to onboarding if user is not onboarded
  def ensure_onboarded
    redirect_to onboarding_path if user_signed_in? && !current_user.onboarded?
  end

  # Redirect to dashboard after sign in
  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
