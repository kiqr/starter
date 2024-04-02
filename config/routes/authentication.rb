# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

# User personal accounts.
scope module: :users, path: :users do
  get "onboarding" => "onboarding#new"
  post "onboarding" => "onboarding#create"

  get "two-factor" => "two_factor#show", :as => :edit_two_factor
  get "two-factor/new" => "two_factor#new", :as => :new_two_factor
  get "two-factor/setup" => "two_factor#setup", :as => :setup_two_factor
  post "two-factor/verify" => "two_factor#verify", :as => :verify_two_factor

  get "delete" => "cancellations#show", :as => :delete_user_registration
end

scope "(/team/:account_id)", account_id: %r{[^/]+} do
  resource :account, only: [:edit, :update], path: "profile"
end
