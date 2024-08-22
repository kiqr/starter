class Users::Settings::ProfilesController < Users::Settings::ApplicationController
  before_action :setup_user, only: [ :show, :update, :cancel_pending_email ]
  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.settings.user_profile"), user_settings_profile_path
  end

  # PATCH /settings/profile
  def update
    if @user.update(user_profile_params)
      kiqr_flash_message(:success, :profile_updated)
      redirect_to user_settings_profile_path
    else
      render :show, status: :unprocessable_content
    end
  end


  def cancel_pending_email
    @user.cancel_pending_email_change!
    kiqr_flash_message_now(:notice, :email_change_pending_cancelled)

    render turbo_stream: [
      turbo_stream.remove("pending_email_notification"),
      render_flash_messages_stream
    ]
  end

  private

  def user_profile_params
    personal_account_attributes = Kiqr.config.account_attributes.prepend(:id)
    params.require(:user).permit(:email, :time_zone, :locale, personal_account_attributes: personal_account_attributes)
  end
end
