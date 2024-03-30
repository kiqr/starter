# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

# User personal accounts.
scope module: :users, path: :users do
  get "onboarding" => "onboarding#new"
  post "onboarding" => "onboarding#create"
end

scope "(/team/:account_id)", account_id: %r{[^/]+} do
  resource :account, only: [:edit, :update], path: "profile"
end
