class ApplicationController < ActionController::Base
  include Kiqr::SetCurrentAttributes
  include Kiqr::RendersSubmenu
  include Kiqr::CurrentAccountHelper
  include Kiqr::UrlHelper

  # => Controller hooks
  before_action :authenticate_user!
  before_action :ensure_onboarded, unless: :devise_controller?
  before_action :setup_locales
  before_action :add_root_basecrumbs

  # => Rails configurations
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Add more types of flash message to match the available variants of Irelia::Notification::Component.
  add_flash_types :success, :warning

  private

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

  # Add the dashboard breadcrumb
  def add_root_basecrumbs
    return unless user_signed_in?

    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, dashboard_path
  end

  # Set a flash message with a translation key
  def kiqr_flash_message(type, message, **kwargs)
    flash[type] = I18n.t("flash_messages.#{message}", **kwargs)
  end

  # The locale is set to the user's locale if present, otherwise it is set to the default locale
  # Get available locales and default_locale from Kiqr::Config
  def setup_locales
    I18n.default_locale = Kiqr::Config.default_locale
    I18n.available_locales = Kiqr::Config.available_locales
    I18n.locale = current_user&.locale&.to_sym || I18n.default_locale
  end
end
