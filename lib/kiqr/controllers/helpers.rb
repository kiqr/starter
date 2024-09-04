module Kiqr
  module Controllers
    # These helpers are methods added to ApplicationController automatically
    # when the engine is loaded.
    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :current_account, :current_member, :onboarded?, :personal_account
      end

      # Get the current account
      # @return [Account] the current account
      def current_account
        Kiqr::CurrentAttributes.account
      end

      # Get the current member associated with the current account and user
      # @return [Member, nil] the current member or nil if not found
      def current_member
        @current_member ||= begin
          return unless current_account

          current_account.members.includes(:user).find_by(user: current_user)
        end
      end

      # Check if the user is onboarded
      # @return [Boolean] true if the user is onboarded
      def onboarded?
        current_user&.onboarded?
      end

      # Get the personal account of the user
      # @return [Account] the personal account of the user
      def personal_account
        current_user&.personal_account
      end

      # Redirect to onboarding if user is not onboarded
      # @return [Redirect, nil]
      def ensure_onboarded
        return if devise_controller? # Skip onboarding check for devise controllers

        redirect_to onboarding_path if user_signed_in? && !current_user.onboarded?
      end

      # Ensure that the user has selected a team account before proceeding.
      # @return [Redirect, nil]
      def ensure_team_account
        unless current_account.team?
          kiqr_flash_message :alert, :team_account_required
          redirect_to dashboard_path
        end
      end

      # Render flash messages as turbo stream
      def render_flash_messages_stream
        turbo_stream.replace("flash_messages", partial: "kiqr/shared/flash_messages")
      end
    end
  end
end
