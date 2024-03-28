# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}

# User personal accounts.
scope module: :users, path: :users do
  get "onboarding" => "onboarding#new"
  post "onboarding" => "onboarding#create"
end
