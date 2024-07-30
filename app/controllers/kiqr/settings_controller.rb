module Kiqr
  class SettingsController < ApplicationController
    before_action :setup_user, only: %i[edit update]

    def update
      @user.assign_attributes(user_params)

      if @user.valid?
        Kiqr::Services::Users::Update.call!(user: @user)
        kiqr_flash_message(:notice, :settings_updated)
        redirect_to edit_settings_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def form_submit_path
      settings_path
    end
    helper_method :form_submit_path

    def form_method
      :patch
    end
    helper_method :form_method

    private

    def setup_user
      @user = current_user
    end

    def user_params
      personal_account_attributes = Kiqr.config.account_attributes.prepend(:id)
      params.require(:user).permit(:time_zone, :locale, personal_account_attributes: personal_account_attributes)
    end
  end
end
