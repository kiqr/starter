module Kiqr
  module Errors
    # Raised when trying to delete an account owner.
    class AccountOwnerDeletionError < StandardError; end

    # Raised when trying to delete an account with more than one member.
    class AccountWithMembersDeletionError < StandardError; end
  end
end
