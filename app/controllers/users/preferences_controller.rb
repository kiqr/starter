class Users::PreferencesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(preferences_params)
      redirect_to edit_user_preferences_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def options_for_locale
    I18n.available_locales.map do |locale|
      [I18n.t("languages.#{locale}"), locale]
    end
  end
  helper_method :options_for_locale

  def preferences_params
    params.require(:user).permit(:time_zone, :locale)
  end
end
