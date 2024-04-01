class ApplicationController < ActionController::Base
  include SetCurrentAttributes
  include CurrentHelper

  before_action :authenticate_user!
  before_action :ensure_onboarded, unless: :devise_controller?

  # Strong parameters for account.
  # Used for account creation and update.
  def account_permitted_parameters
    params.require(:account).permit(:name)
  end

  private

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

  # Override the method to change the sign-in redirect path
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Override the method to change the sign-out redirect path
  def after_sign_out_path_for(resource_or_scope)
    # Generate the root path without default URL options
    uri = URI.parse(root_url)
    uri.query = nil # Remove any query parameters
    uri.to_s
  end
end
