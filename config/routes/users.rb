# => Devise routes
# Custom wrapper for Devise routes.
devise_for :users,
  path_names: { sign_in: "login", sign_up: "create-account" },
  controllers: {
    registrations: "kiqr/registrations",
    sessions: "kiqr/sessions",
    omniauth_callbacks: "kiqr/omniauth_callbacks"
  }

devise_scope :user do
  get "settings/delete-user", controller: "kiqr/registrations", action: :delete, as: :delete_user_registration
end

# => Users
# Routes related to the User model.
scope "settings" do
  resource "profile",
    only: [ :show, :update ],
    controller: "kiqr/users/settings/profiles",
    as: :user_settings_profile do
      delete "cancel-pending-email"
    end

  resource "password",
    only: [ :show, :update, :create ],
    controller: "kiqr/users/settings/passwords",
    as: :user_settings_password

  resource "two_factor",
    only: [ :show, :new, :create, :destroy ],
    controller: "kiqr/users/settings/two_factor",
    as: :user_settings_two_factor,
    path: "two-factor"

  resources "accounts",
    only: [ :index, :new, :create ],
    controller: "kiqr/users/settings/accounts",
    as: :user_settings_accounts,
    path: "teams"
end
