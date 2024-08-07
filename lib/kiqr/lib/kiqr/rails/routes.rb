module ActionDispatch
  module Routing
    class Mapper
      def kiqr_routes(options = {})
        # Set default options for controllers if not set.
        options = default_controllers(options)

        dashboard_route(options)
        account_routes(options)
        invitation_routes(options)
        omniauth_routes(options)
        development_routes(options) if Rails.env.development?

        scope path: :users do
          get "two-factor/disable", controller: "kiqr/two_factor", action: "disable", as: :disable_two_factor
          delete "two-factor/destroy", controller: "kiqr/two_factor", action: "destroy", as: :destroy_two_factor
        end
      end

      private

      # => Default controllers
      # Set default options for controllers if not set.
      def default_controllers(options)
        options[:controllers] ||= {}
        options[:controllers][:dashboard] ||= "dashboard"
        options[:controllers][:accounts] ||= "kiqr/accounts"
        options[:controllers][:account_users] ||= "kiqr/account_users"
        options[:controllers][:invitations] ||= "kiqr/invitations"
        options[:controllers][:onboarding] ||= "kiqr/onboarding"
        options[:controllers][:registrations] ||= "kiqr/registrations"
        options[:controllers][:sessions] ||= "kiqr/sessions"
        options[:controllers][:settings] ||= "kiqr/settings"
        options[:controllers][:omniauth] ||= "kiqr/omniauth"
        options
      end

      # => Dashboard route
      # Routes for the dashboard.
      def dashboard_route(options)
        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          get "dashboard", controller: options[:controllers][:dashboard], action: :show
        end
      end

      # => Development routes
      # Routes only available in development environment.
      def development_routes(options)
      end

      # => OmniAuth routes
      # These routes are required for the OmniAuth to function properly.
      def omniauth_routes(options)
        match "auth/:provider/callback", controller: options[:controllers][:omniauth], action: :callback, via: %i[get post]
      end

      # => Account routes
      def account_routes(options)
        resources :accounts, controller: options[:controllers][:accounts], only: [ :new, :create ]
        get "select-account", controller: options[:controllers][:accounts], action: :select, as: :select_account

        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          resource :account, only: [ :edit, :update ], controller: options[:controllers][:accounts]
          resources :account_users, controller: options[:controllers][:account_users], only: [ :index, :edit, :update, :destroy ], path: "members"
        end
      end

      # => Teamable routes
      # Routes inside this block will be prefixed with /team/<team_id> if
      # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
      def teamable_scope(&)
        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          yield
        end
      end

      # => Invitation routes
      # Routes for team admins to create or decline and users to accept or decline team invitations.
      def invitation_routes(options)
        # Invitee
        resources :invitations, controller: options[:controllers][:invitations], only: %i[show] do
          post :accept, on: :member
          post :reject, on: :member
        end

        # Inviter
        teamable_scope do
          resources :account_invitations, controller: "kiqr/accounts/invitations", only: [ :index, :new, :create, :destroy ]
        end
      end
    end
  end
end
