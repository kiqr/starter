module Accounts
  extend ActiveSupport::Concern

  included do
    helper_method :current_account
    before_action :redirect_to_onboarding
  end

  def current_account
    @current_account ||= current_user&.personal_account
  end

  def fetch_account_from_params
    nil if params[:account_id].blank?
    # current_user.accounts.find_puid(params[:account_id])
  end

  private

  # Redirect to onboarding if user is not onboarded
  def redirect_to_onboarding
    redirect_to onboarding_path if user_signed_in? && !current_user.onboarded?
  end
end
