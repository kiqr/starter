module Kiqr
  module Errors
    class DeleteTeamOwnerError < StandardError
      def initialize(msg = "Can't delete the owner of a team")
        super
      end
    end
  end
end
