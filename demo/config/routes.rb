Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # => KIQR core routes
  # These routes are required for the KIQR core to function properly.
  kiqr_routes

  # => Letter Opener Web
  # This route is required for the Letter Opener Web to function properly.
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  # => Teamable scope
  # Routes inside this block will be prefixed with /team/<team_id> if
  # the user is signed in to a team account. Otherwise, they won't be prefixed at all.
  teamable_scope do
  end

  # Defines the root path route ("/")
  root "public#landing_page"
end
