# Devise routes for user authentication
devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}
