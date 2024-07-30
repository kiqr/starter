Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # => KIQR core routes
  # These routes are required for the KIQR core to function properly.
  kiqr_routes

  # => Development
  # These routes are only available in development environment.
  # Loads file: config/routes/development.rb
  draw "development" if Rails.env.development?

  # => Users
  # Routes accessed under the /users route scope.
  draw "users"

  # => App routes
  # Routes inside this block will be prefixed with /team/<team_id> if
  # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
  #
  # Example:
  # /team/:team_id/dashboard <- if user is signed in to a team account
  # /dashboard <- if user is browsing the app without a team account
  #
  teamable_scope do
    # Define your application routes inside this block!
  end

  # Defines the root path route ("/")
  root "public#landing_page"
end
