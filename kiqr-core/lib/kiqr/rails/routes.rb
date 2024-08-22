module ActionDispatch::Routing
  class Mapper
    def kiqr_routes(options = {})
      # Setup default controller paths
      options[:controllers] ||= {}
      options[:controllers][:account_settings_profiles] ||= "kiqr/accounts/settings/profiles"
      options[:controllers][:account_settings_members] ||= "kiqr/accounts/settings/members"

      kiqr_account_routes(options)
    end

    private

    # => Account scope
    # Routes inside this scope will be prefixed with /team/<team_id> if
    # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
    #
    # Account scope can be forced to be present by passing force: true.
    def account_scope(force: false, &block)
      pattern = force ? "/team/:account_id" : "(/team/:account_id)"
      scope pattern, account_id: %r{[^/]+} do
        yield
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
