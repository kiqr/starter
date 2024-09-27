# Handles Devise authentication and user password management functionality.
module Kiqr
  module Users
    module Authentication
      extend ActiveSupport::Concern

      included do
        # Devise modules for user authentication and session management.
        devise :registerable, :recoverable, :rememberable, :validatable, :confirmable,
              :lockable, :timeoutable, :trackable, :omniauthable

        # Used by Devise to check if the user's password is required.
        # @return [Boolean] whether the password is required or not.
        def password_required?
          return false if skip_password_validation
          super
        end
      end

      # Virtual attribute to skip password validation while saving
      attr_accessor :skip_password_validation

      # Allows users to update their password without providing their current password.
      # @param params [Hash] user params to update the password.
      # @return [Boolean] result of the password update operation.
      def create_password(params)
        params.delete(:current_password)
        result = update(params)
        clean_up_passwords
        result
      end

      # Cancels a pending email change by resetting unconfirmed email and confirmation sent timestamps.
      # @return [void]
      def cancel_pending_email_change!
        update!(unconfirmed_email: nil, confirmation_sent_at: nil)
      end
    end
  end
end
