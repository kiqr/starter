module Kiqr
  class SettingsController < KiqrController
    before_action :setup_user, only: %i[edit update]

    def update
      if @user.update(preferences_params)
        kiqr_flash_message(:notice, :settings_updated)
        redirect_to edit_settings_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def setup_user
      @user = current_user
    end

    def options_for_locale
      I18n.available_locales.map do |locale|
        [I18n.t("languages.#{locale}"), locale]
      end
    end
    helper_method :options_for_locale

    def preferences_params
      personal_account_attributes = Kiqr.config.account_attributes.prepend(:id)
      params.require(:user).permit(:time_zone, :locale, personal_account_attributes: personal_account_attributes)
    end
  end
end
