class Users::Settings::ProfilesController < Users::Settings::ApplicationController
  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.user_profile"), user_settings_profile_path
  end

  # GET /settings/profile
  def show
    @user = find_user
  end

  # PATCH /settings/profile
  def update
    @user = find_user
    @user.assign_attributes(user_profile_params)

    if @user.valid?
      Kiqr::Services::Users::Update.call!(user: @user)
      kiqr_flash_message(:success, :profile_updated)
      redirect_to user_settings_profile_path
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def find_user
    User.find(current_user.id)
  end

  def user_profile_params
    personal_account_attributes = Kiqr.config.account_attributes.prepend(:id)
    params.require(:user).permit(:time_zone, :locale, personal_account_attributes: personal_account_attributes)
  end
end
