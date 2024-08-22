namespace :user, path: nil, module: :users do
  namespace :settings do
    resource "profile", only: [ :show, :update ]
    resource "password", only: [ :show, :update, :create ]
    resource "two_factor", only: [ :show, :new, :create, :destroy ], controller: "two_factor", path: "two-factor"
    resources "accounts", only: [ :index, :new, :create ], path: "teams"

    delete "profile/cancel-pending-email", controller: "profiles", action: :cancel_pending_email, as: :cancel_pending_email
  end
end
