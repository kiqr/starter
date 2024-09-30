class Users::Settings::PasswordsController < Users::Settings::BaseController
  before_action :setup_user, only: [ :show, :edit, :update, :create ]
  before_action do
    add_breadcrumb I18n.t("breadcrumbs.settings.users.password.root"), user_settings_password_path
  end

  # GET /settings/profile
  def show
    if @user.encrypted_password.blank?
      render :new
    else
      render :edit
    end
  end

  def update
    if @user.update_with_password(user_password_params)
      kiqr_flash_message :success, :password_updated
      bypass_sign_in(@user) if sign_in_after_change_password?
      redirect_to user_settings_password_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  def create
    if @user.create_password(user_password_params)
      kiqr_flash_message :success, :password_created
      bypass_sign_in(@user) if sign_in_after_change_password?
      redirect_to user_settings_password_path
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def sign_in_after_change_password?
    Devise.sign_in_after_change_password
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
