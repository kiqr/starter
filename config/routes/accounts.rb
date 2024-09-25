# => Accounts
# Routes related to the Account model.
account_scope(force: true) do
  scope "settings" do
    resource "profile",
      controller: "kiqr/accounts/settings/profiles",
      as: :account_settings_profile,
      only: [ :show, :update ]

    resources "members",
      controller: "kiqr/accounts/settings/members",
      as: :account_settings_members,
      only: [ :index, :new, :create, :show, :destroy ] do
        get :invitation_link_modal, on: :member
    end

    resource "delete",
      controller: "kiqr/accounts/settings/delete",
      as: :account_settings_delete,
      only: [ :show, :destroy ]
  end
end
