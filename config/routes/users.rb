devise_for :users, path_names: { sign_in: "login", sign_up: "create-account" }, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

devise_scope :user do
  get "users/cancel-account", controller: "users/registrations", action: :cancel, as: :delete_user_registration
end

scope :users do
  get "onboarding", controller: "users/onboarding", action: :new
  patch "onboarding", controller: "users/onboarding", action: :update
end

namespace :user, path: nil, module: :users do
  namespace :settings do
    resource "profile", only: [ :show, :update ]
    resource "password", only: [ :show, :update, :create ]

    delete "profile/cancel-pending-email", controller: "profiles", action: :cancel_pending_email, as: :cancel_pending_email
  end
end
