class Users::RegistrationsController < Devise::RegistrationsController
  renders_submenu partial: "users/settings/navigation", only: [ :cancel ]

  skip_before_action :require_no_authentication, only: [ :cancel ]
  before_action :authenticate_user!, only: [ :cancel ]

  # GET /settings/cancel
  def cancel
    add_breadcrumb t("breadcrumbs.settings.root"), user_settings_profile_path
    add_breadcrumb t("breadcrumbs.settings.cancel_user"), cancel_user_registration_path
    @conflicting_account_users = current_user.account_users.where(owner: true)
  end

  # DELETE /users
  def destroy
    # Don't let user cancel their accounts if they are an owner of a team.
    if current_user.account_users.find_by(owner: true)
      kiqr_flash_message(:alert, :cant_cancel_while_team_owner)
      return redirect_to cancel_user_registration_path
    end

    # TODO: Don't let user delete account if they have active subscriptions.
    # TODO: Verify otp before deleting account
    # TODO: Don't delete account immediately, but mark it as deleted and delete it after 30 days.
    # TODO: Send email to user with confirmation link to delete account.'

    super # Inherits from Devise::RegistrationsController
  end
end
