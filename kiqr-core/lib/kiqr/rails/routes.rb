module ActionDispatch::Routing
  class Mapper
    def kiqr_routes(options = {})
      # Setup default controller paths
      options[:controllers] ||= {}
      options[:controllers][:account_settings_profiles] ||= "kiqr/accounts/settings/profiles"
      options[:controllers][:account_settings_members] ||= "kiqr/accounts/settings/members"
      options[:controllers][:onboarding] ||= "kiqr/onboarding"
      options[:controllers][:invitations] ||= "kiqr/users/invitations"
      options[:controllers][:registrations] ||= "kiqr/registrations"
      options[:controllers][:sessions] ||= "kiqr/sessions"
      options[:controllers][:omniauth_callbacks] ||= "kiqr/omniauth_callbacks"

      devise_routes(options)
      kiqr_account_routes(options)
      kiqr_invitation_routes(options)
      resource :onboarding, only: [ :show, :update ], controller: options[:controllers][:onboarding]
    end

    private

    # => Account scope
    # Routes inside this scope will be prefixed with /team/<team_id> if
    # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
    # Account scope can be forced to be present by passing force: true.
    def account_scope(force: false, &block)
      pattern = force ? "/team/:account_id" : "(/team/:account_id)"
      scope pattern, account_id: %r{[^/]+} do
        yield
      end
    end

    # => Devise routes
    # Custom wrapper for Devise routes.
    def devise_routes(options = {})
      devise_for :users,
        path_names: { sign_in: "login", sign_up: "create-account" },
        controllers: {
          registrations: options[:controllers][:registrations],
          sessions: options[:controllers][:sessions],
          omniauth_callbacks: options[:controllers][:omniauth_callbacks]
        }

      devise_scope :user do
        get "settings/delete-user", controller: options[:controllers][:registrations], action: :delete, as: :delete_user_registration
      end
    end

    # => User invitations
    def kiqr_invitation_routes(options = {})
      resource :invitation, only: [ :show, :update ], controller: options[:controllers][:invitations], path: "invitation/:token", as: :user_invitation do
        patch "accept", action: :accept_invitation
        delete "decline", action: :decline_invitation
      end
    end

    # => Accounts
    # Routes related to the Account model.
    def kiqr_account_routes(options = {})
      account_scope(force: true) do
        scope "settings" do
          resource "profile",
            controller: options[:controllers][:account_settings_profiles],
            as: :account_settings_profile,
            only: [ :show, :update ]

          resources "members",
            controller: options[:controllers][:account_settings_members],
            as: :account_settings_members,
            only: [ :index, :new, :create, :edit, :destroy ] do
              get :invitation_link_modal, on: :member
          end
        end
      end
    end
  end
end
