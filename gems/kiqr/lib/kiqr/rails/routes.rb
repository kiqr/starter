module ActionDispatch
  module Routing
    class Mapper
      def kiqr_routes(options = {})
        # Set default options for controllers if not set.
        options = default_controllers(options)

        account_routes(options)
        devise_routes(options)
        invitation_routes(options)
        onboarding_routes(options)
        omniauth_routes(options)
        development_routes(options) if Rails.env.development?

        scope path: :users do
          get "two-factor", controller: options[:controllers][:two_factor], action: "show", as: :edit_two_factor
          get "two-factor/new", controller: options[:controllers][:two_factor], action: "new", as: :new_two_factor
          get "two-factor/setup", controller: options[:controllers][:two_factor], action: "setup", as: :setup_two_factor
          get "two-factor/disable", controller: options[:controllers][:two_factor], action: "disable", as: :disable_two_factor
          post "two-factor/verify", controller: options[:controllers][:two_factor], action: "verify", as: :verify_two_factor
          delete "two-factor/destroy", controller: options[:controllers][:two_factor], action: "destroy", as: :destroy_two_factor
          resource :settings, controller: options[:controllers][:settings], only: %i[edit update], as: :settings
        end
      end

      private

      # => Default controllers
      # Set default options for controllers if not set.
      def default_controllers(options)
        options[:controllers] ||= {}
        options[:controllers][:accounts] ||= "kiqr/accounts"
        options[:controllers][:account_users] ||= "kiqr/account_users"
        options[:controllers][:invitations] ||= "kiqr/invitations"
        options[:controllers][:onboarding] ||= "kiqr/onboarding"
        options[:controllers][:registrations] ||= "kiqr/registrations"
        options[:controllers][:sessions] ||= "kiqr/sessions"
        options[:controllers][:two_factor] ||= "kiqr/two_factor"
        options[:controllers][:settings] ||= "kiqr/settings"
        options[:controllers][:omniauth] ||= "kiqr/omniauth"
        options
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
        resources :accounts, controller: options[:controllers][:accounts], only: [:new, :create]
        get "select-account", controller: options[:controllers][:accounts], action: :select, as: :select_account

        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          resource :account, only: [:edit, :update], controller: options[:controllers][:accounts]
          resources :account_users, controller: options[:controllers][:account_users], only: [:index, :edit, :update, :destroy], path: "members"
        end
      end

      # => Authentication routes
      def devise_routes(options)
        devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}, controllers: {
          registrations: options[:controllers][:registrations],
          sessions: options[:controllers][:sessions]
        }

        devise_scope :user do
          get "users/cancel-account", controller: options[:controllers][:registrations], action: :cancel, as: :delete_user_registration
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
          resources :account_invitations, controller: "kiqr/accounts/invitations", only: [:index, :new, :create, :destroy]
        end
      end

      # => Onboarding routes
      # Routes for onboarding steps.
      def onboarding_routes(options)
        scope path: :users do
          get "onboarding", controller: options[:controllers][:onboarding], action: :new
          post "onboarding", controller: options[:controllers][:onboarding], action: :create
        end
      end
    end
  end
end
