Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # => KIQR core routes
  # These routes are required for the KIQR core to function properly.
  # Do not remove or modify these routes unless you know what you're doing.
  draw :development
  draw :authentication

  # => Application routes
  # Routes inside this block will be prefixed with /team/<team_id> if
  # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
  scope "(/team/:account_id)", account_id: %r{[^/]+} do
    get "dashboard" => "dashboard#show"
  end

  # Defines the root path route ("/")
  root "public#landing_page"
end
