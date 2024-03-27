class ApplicationController < ActionController::Base
  include SetCurrentAttributes

  before_action :authenticate_user!
  before_action :ensure_onboarded, unless: :devise_controller?

  private

  # Redirect to onboarding if user is not onboarded
  def ensure_onboarded
    redirect_to accounts_onboarding_path if user_signed_in? && !current_user.onboarded?
  end

  # Redirect to dashboard after sign in
  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
