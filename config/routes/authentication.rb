# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}

# Setup user's personal account'
get "onboarding" => "onboarding#new"
post "onboarding" => "onboarding#create"
