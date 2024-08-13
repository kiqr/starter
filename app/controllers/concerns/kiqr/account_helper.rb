module Kiqr
  module AccountHelper
    extend ActiveSupport::Concern

    included do
      helper_method :current_account, :onboarded?, :personal_account
    end

    # Redirect to onboarding if user is not onboarded
    def ensure_onboarded
      return if devise_controller? # Skip onboarding check for devise controllers
      return unless user_signed_in? && !current_user.onboarded? # Check if user is not onboarded

      redirect_to user_onboarding_path
    end

    # Get the current account
    def current_account
      Current.account
    end

    # Check if the user is onboarded
    def onboarded?
      current_user&.onboarded?
    end

    # Get the personal account of the user
    def personal_account
      current_user&.personal_account
    end

    private

    # Ensure that the user has selected a team account before proceeding.
    def ensure_team_account
      unless current_account.team?
        kiqr_flash_message :alert, :team_account_required
        redirect_to dashboard_path
      end
    end
  end
end
