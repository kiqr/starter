Rails.application.routes.draw do
  # User authentication
  devise_for :users, path_names: {sign_in: "login", sign_up: "create-account"}, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Account management
  resources :accounts, only: [:new, :create], controller: "kiqr/accounts"
  get "select-account", controller: "kiqr/accounts", action: :select, as: :select_account

  scope "(/team/:account_id)", account_id: %r{[^/]+} do
    resource :account, only: [:edit, :update], path: "profile", controller: "kiqr/accounts"
  end
end
