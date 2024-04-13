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
      end

      private

      # => Default controllers
      # Set default options for controllers if not set.
      def default_controllers(options)
        options[:controllers] ||= {}
        options[:controllers][:accounts] ||= "kiqr/accounts"
        options[:controllers][:invitations] ||= "kiqr/invitations"
        options[:controllers][:onboarding] ||= "kiqr/onboarding"
        options[:controllers][:registrations] ||= "kiqr/registrations"
        options[:controllers][:sessions] ||= "users/sessions"
        options
      end

      # => Account routes
      def account_routes(options)
        resources :accounts, controller: options[:controllers][:accounts], only: [:new, :create]
        get "select-account", controller: options[:controllers][:accounts], action: :select, as: :select_account

        scope "(/team/:account_id)", account_id: %r{[^/]+} do
          resource :account, only: [:edit, :update], path: "profile", controller: options[:controllers][:accounts]
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
