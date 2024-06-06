module Kiqr
  module Errors
    class InvitationExpiredError < StandardError
      def initialize(msg = "Invitation has already expired")
        super
      end
    end
  end
end
