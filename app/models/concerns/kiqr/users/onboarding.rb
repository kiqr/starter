# Handles user onboarding logic.
module Kiqr
  module Users
    module Onboarding
      extend ActiveSupport::Concern

      # Checks if the user has completed the onboarding process.
      # Onboarding is considered complete if the personal account exists and is persisted.
      # @return [Boolean] whether the user is onboarded or not.
      def onboarded?
        personal_account&.persisted?
      end
    end
  end
end
