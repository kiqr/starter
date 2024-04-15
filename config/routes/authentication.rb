# User personal accounts.
scope module: :users, path: :users do
  get "two-factor" => "two_factor#show", :as => :edit_two_factor
  get "two-factor/new" => "two_factor#new", :as => :new_two_factor
  get "two-factor/setup" => "two_factor#setup", :as => :setup_two_factor
  get "two-factor/disable" => "two_factor#disable", :as => :disable_two_factor
  post "two-factor/verify" => "two_factor#verify", :as => :verify_two_factor
  delete "two-factor/destroy" => "two_factor#destroy", :as => :destroy_two_factor

  resource :preferences, only: %i[edit update], as: :user_preferences
end
