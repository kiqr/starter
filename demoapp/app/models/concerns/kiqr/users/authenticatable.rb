module Kiqr
  module Users
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        # Default devise modules.
        devise :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable
      end

      # Alternative to the devise update_with_password method to
      # allow users to add a password without providing their current password.
      def create_password(params)
        params.delete(:current_password)
        result = update(params)
        clean_up_passwords
        result
      end

      # Reset unconfirmed email and confirmation sent at.
      # This is useful when a user cancels their email change.
      def cancel_pending_email_change!
        update!(unconfirmed_email: nil, confirmation_sent_at: nil)
      end
    end
  end
end
