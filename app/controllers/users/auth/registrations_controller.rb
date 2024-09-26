class Users::Auth::RegistrationsController < Devise::RegistrationsController
  layout "application", only: %i[delete destroy]
  renders_submenu partial: "kiqr/users/settings/navigation", only: [ :delete ]

  skip_before_action :require_no_authentication, only: [ :cancel ]
  before_action :authenticate_user!, only: [ :cancel ]

  # GET /settings/cancel
  def delete
    add_breadcrumb t("kiqr.breadcrumbs.settings.root"), user_settings_profile_path
    add_breadcrumb t("kiqr.breadcrumbs.settings.users.delete_user"), delete_user_registration_path
    @conflicting_members = current_user.members.where(owner: true)
  end

  # DELETE /users
  def destroy
    # Don't let user cancel their accounts if they are an owner of a team.
    if current_user.members.find_by(owner: true)
      kiqr_flash_message(:alert, :cant_cancel_while_team_owner)
      return redirect_to delete_user_registration_path
    end

    # TODO: Don't let user delete account if they have active subscriptions.
    # TODO: Verify otp before deleting account
    # TODO: Don't delete account immediately, but mark it as deleted and delete it after 30 days.
    # TODO: Send email to user with confirmation link to delete account.'

    super # Inherits from Devise::RegistrationsController
  end
end
