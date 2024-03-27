# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}

# Routes for account creation
scope module: :accounts, path: nil do
  get "onboarding" => "onboarding#new"
  post "onboarding" => "onboarding#create"
end
