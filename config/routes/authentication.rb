# User personal accounts.
scope module: :users, path: :users do
  resource :preferences, only: %i[edit update], as: :user_preferences
end
