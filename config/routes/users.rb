# => Authentication with Devise
devise_for :users, path_names: { sign_in: "login", sign_up: "create-account" }, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

devise_scope :user do
  get "users/cancel-account", controller: "users/registrations", action: :cancel, as: :delete_user_registration
end

# => Authentication with OmniAuth (social accounts)
match "auth/:provider/callback", controller: "users/omniauth", action: :callback, via: %i[get post]

# => User settings
namespace :user, path: nil, module: :users do
  get "onboarding",   to: "onboarding#new"
  patch "onboarding", to: "onboarding#update"

  resource :invitation, only: [ :show, :update ], controller: "invitations", path: "invitation/:token"

  namespace :settings do
    resource "profile", only: [ :show, :update ]
    resource "password", only: [ :show, :update, :create ]
    resource "two_factor", only: [ :show, :new, :create, :destroy ], controller: "two_factor", path: "two-factor"
    resources "accounts", only: [ :index, :new, :create ], path: "teams"

    delete "profile/cancel-pending-email", controller: "profiles", action: :cancel_pending_email, as: :cancel_pending_email
  end
end
