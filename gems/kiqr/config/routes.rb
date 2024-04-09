Rails.application.routes.draw do
  # User authentication
  devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
end
