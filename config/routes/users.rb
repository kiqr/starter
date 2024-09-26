# => Devise routes
devise_for :users,
  path_names: { sign_in: "login", sign_up: "create-account" },
  controllers: {
    registrations: "users/auth/registrations",
    sessions: "users/auth/sessions",
    omniauth_callbacks: "users/auth/omniauth_callbacks"
  }

devise_scope :user do
  get "settings/delete-user", controller: "users/auth/registrations", action: :delete, as: :delete_user_registration
end

# => Onboarding
resource :onboarding, only: [ :show, :update ], controller: "users/auth/onboarding"

# => User invitations
resource :invitation, only: [ :show, :update ], controller: "users/invitations", path: "invitation/:token", as: :user_invitation do
  patch "accept", action: :accept_invitation
  delete "decline", action: :decline_invitation
end

# => User settings
scope "settings" do
  resource "profile",
    only: [ :show, :update ],
    controller: "users/settings/profiles",
    as: :user_settings_profile do
      delete "cancel-pending-email"
    end

  resource "password",
    only: [ :show, :update, :create ],
    controller: "users/settings/passwords",
    as: :user_settings_password

  resource "two_factor",
    only: [ :show, :new, :create, :destroy ],
    controller: "users/settings/two_factor",
    as: :user_settings_two_factor,
    path: "two-factor"

  resources "accounts",
    only: [ :index, :new, :create ],
    controller: "users/settings/accounts",
    as: :user_settings_accounts,
    path: "teams"
end
