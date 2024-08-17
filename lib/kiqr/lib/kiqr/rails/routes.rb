module ActionDispatch
  module Routing
    class Mapper
      def kiqr_routes(options = {})
        # Set default options for controllers if not set.
        options = default_controllers(options)
      end

      private

      # => Default controllers
      # Set default options for controllers if not set.
      def default_controllers(options)
        options[:controllers] ||= {}
        options[:controllers][:account_users] ||= "kiqr/account_users"
        options[:controllers][:invitations] ||= "kiqr/invitations"
        options[:controllers][:onboarding] ||= "kiqr/onboarding"
        options[:controllers][:registrations] ||= "kiqr/registrations"
        options[:controllers][:sessions] ||= "kiqr/sessions"
        options[:controllers][:settings] ||= "kiqr/settings"
        options
      end

      # => Teamable routes
      # Routes inside this block will be prefixed with /team/<team_id> if
      # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
      def teamable_scope(&)
        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          yield
        end
      end
    end
  end
end
