module ActionDispatch::Routing
  class Mapper
    def kiqr_routes(options = {})
      # Setup default controller paths
      options[:controllers] ||= {}
      options[:controllers][:account_settings_profile] ||= "kiqr/accounts/settings/profiles"
      options[:controllers][:account_settings_members] ||= "kiqr/accounts/settings/members"
      options[:controllers][:account_settings_delete] ||= "kiqr/accounts/settings/delete"
      options[:controllers][:onboarding] ||= "kiqr/onboarding"
      options[:controllers][:invitations] ||= "kiqr/users/invitations"

      kiqr_account_routes(options)
      kiqr_invitation_routes(options)

      resource :onboarding, only: [ :show, :update ], controller: options[:controllers][:onboarding]
    end

    protected

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
            controller: options[:controllers][:account_settings_profile],
            as: :account_settings_profile,
            only: [ :show, :update ]

          resources "members",
            controller: options[:controllers][:account_settings_members],
            as: :account_settings_members,
            only: [ :index, :new, :create, :show, :destroy ] do
              get :invitation_link_modal, on: :member
          end

          resource "delete",
            controller: options[:controllers][:account_settings_delete],
            as: :account_settings_delete,
            only: [ :show, :destroy ]
        end
      end
    end
  end
end
