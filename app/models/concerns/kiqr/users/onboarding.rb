# Handles user onboarding logic.
module Kiqr
  module Users
    module Onboarding
      extend ActiveSupport::Concern

      # Checks if the user has completed the onboarding process.
      # Onboarding is considered complete if all the below conditions are met.
      # @return [Boolean] whether the user is onboarded or not.
      def onboarded?
        profile.present? && profile.persisted?
      end
    end
  end
end
