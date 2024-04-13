class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:cancel]
  before_action :authenticate_user!, only: [:cancel]

  def cancel
    @conflicting_account_users = current_user.account_users.where(owner: true)
  end

  def destroy
    # Don't let user cancel their accounts if they are an owner of a team.
    if current_user.account_users.find_by(owner: true)
      flash[:alert] = I18n.t("users.registrations.destroy.owner_of_team")
      return redirect_to cancel_user_registration_path
    end

    super # Inherits from Devise::RegistrationsController
  end
end
