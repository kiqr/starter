# User personal accounts.
scope module: :users, path: :users do
  get "onboarding" => "onboarding#new"
  post "onboarding" => "onboarding#create"

  get "two-factor" => "two_factor#show", :as => :edit_two_factor
  get "two-factor/new" => "two_factor#new", :as => :new_two_factor
  get "two-factor/setup" => "two_factor#setup", :as => :setup_two_factor
  get "two-factor/disable" => "two_factor#disable", :as => :disable_two_factor
  post "two-factor/verify" => "two_factor#verify", :as => :verify_two_factor
  delete "two-factor/destroy" => "two_factor#destroy", :as => :destroy_two_factor

  get "delete" => "cancellations#show", :as => :delete_user_registration

  resource :preferences, only: %i[edit update], as: :user_preferences
end

scope "(/team/:account_id)", account_id: %r{[^/]+} do
  resources :members, controller: "accounts/members", only: [:index, :edit, :update, :destroy]
end
