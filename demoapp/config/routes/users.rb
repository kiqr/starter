scope "settings" do
  resource "profile",
    only: [ :show, :update ],
    controller: "kiqr/users/settings/profiles",
    as: :user_settings_profile do
      delete "cancel-pending-email"
    end

  # delete "profile/cancel-pending-email",
  #   controller: "kiqr/users/settings/profiles",
  #   action: :cancel_pending_email,
  #   as: :user_settings_cancel_pending_email

  resource "password",
    only: [ :show, :update, :create ],
    controller: "kiqr/users/settings/passwords",
    as: :user_settings_password

  resource "two_factor",
    only: [ :show, :new, :create, :destroy ],
    controller: "kiqr/users/settings/two_factor",
    as: :user_settings_two_factor,
    path: "two-factor"

  resources "accounts",
    only: [ :index, :new, :create ],
    controller: "kiqr/users/settings/accounts",
    as: :user_settings_accounts,
    path: "teams"
end
