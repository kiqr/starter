
module ActionDispatch
  module Routing
    class Mapper
      protected

      # => Account scope
      # Routes inside this scope will be prefixed with /team/<team_id> if
      # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
      # Account scope can be forced to be present by passing force: true.
      def account_scope(force: false, &block)
        pattern = force ? "/team/:account_id" : "(/team/:account_id)"

        # Set the account scope flag so we can check if we are inside an account scope
        @is_account_scope = true

        scope pattern, account_id: %r{[^/]+} do
          yield
        end
      end
    end
  end
end
