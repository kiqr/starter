module Kiqr
  module Framework
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
      before_action :ensure_onboarded, unless: :devise_controller?
      before_action :setup_locale

      include Kiqr::SetCurrentAttributes
      include Kiqr::CurrentHelper

      helper_method :after_select_account_path
    end

    private

    # Set a flash message with a translation key
    def kiqr_flash_message(type, message, **kwargs)
      flash[type] = I18n.t("kiqr.flash_messages.#{message}", **kwargs)
    end

    # Automatically include account_id in all URL options if it is already present in the params.
    # This is used to ensure that all routes are scoped to the current team. Personal account
    # routes are not affected.
    def default_url_options
      { account_id: params[:account_id] }
    end

    # Redirect to onboarding if user is not onboarded
    def ensure_onboarded
      redirect_to onboarding_path if user_signed_in? && !current_user.onboarded?
    end

    # Override the method to change the sign-in redirect path
    def after_sign_in_path_for(resource)
      if session[:after_sign_in_path].present?
        session.delete(:after_sign_in_path)
      elsif current_user.accounts.any?
        select_account_path
      else
        dashboard_path
      end
    end

    # Override the method to change the sign-out redirect path
    def after_sign_out_path_for(resource_or_scope)
      # Generate the root path without default URL options
      uri = URI.parse(root_url)
      uri.query = nil # Remove any query parameters
      uri.to_s
    end

    # Override this method to change the path
    def after_select_account_path(params)
      dashboard_path(params)
    end

    # The locale is set to the user's locale if present, otherwise it is set to the default locale
    # Get available locales and default_locale from Kiqr::Config
    def setup_locale
      I18n.default_locale = Kiqr::Config.default_locale
      I18n.available_locales = Kiqr::Config.available_locales
      I18n.locale = current_user&.locale&.to_sym || I18n.default_locale
    end
  end
end
