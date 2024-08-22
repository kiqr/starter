Rails.application.routes.draw do
  # => Accounts
  # Routes related to the Account model.
  scope "/team/:account_id", account_id: %r{[^/]+} do
    scope "settings" do
      resource "profile",
        controller: "kiqr/accounts/settings/profiles",
        as: :account_settings_profile,
        only: [ :show, :update ]

      resources "members",
        controller: "kiqr/accounts/settings/members",
        as: :account_settings_members,
        only: [ :index, :new, :create, :edit, :destroy ] do
          get :invitation_link_modal, on: :member
      end
    end
  end
end
