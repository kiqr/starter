module Kiqr
  module Services
    module Users
      # Update account service
      # User can update their personal account or if they are part of the team.
      class Update < Kiqr::ApplicationService
        def call(user:)
          @user = user

          user.save!

          success user
        end

        private

        attr_reader :user
      end
    end
  end
end
