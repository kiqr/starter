class ApplicationController < ActionController::Base
  include Kiqr::SetCurrentRequestDetails
  include Kiqr::RendersSubmenu

  # Turn on request forgery protection. Bear in mind that GET and HEAD requests are not checked.
  protect_from_forgery with: :exception, prepend: true

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Add more types of flash message to match the available variants in Irelia::Notification::Component.
  add_flash_types :success, :warning

  # Ensure that a user is signed in and has completed the onboarding process.
  before_action :authenticate_user!
  before_action :ensure_onboarded

  # Set up the base breadcrumbs for the application (Home -> Account name)
  before_action :setup_base_breadcrumbs

  # Automatically include account_id in all URL options if it is already present in the params.
  # This is used to ensure that all routes are scoped to the current team. Personal account
  # routes are not affected.
  def default_url_options
    { account_id: params[:account_id] }
  end

  def kiqr_flash_message(type, message, **kwargs)
    flash[type] = I18n.t("flash_messages.#{message}", **kwargs)
  end

  def kiqr_flash_message_now(type, message, **kwargs)
    flash.now[type] = I18n.t("flash_messages.#{message}", **kwargs)
  end

  protected

  # Redirect path after sign-in. If the user hasn't completed onboarding, redirect to onboarding.
  def after_sign_in_path_for(resource)
    return onboarding_path unless resource.onboarded?

    session.delete(:after_sign_in_path) || dashboard_path
  end

  # Redirect path after sign-out. Always redirect to the root path.
  def after_sign_out_path_for(_resource_or_scope)
    root_path(account_id: nil) # Resets account_id.
  end

  # Redirect path after selecting an account.
  def after_select_account_path(params)
    dashboard_path(params)
  end

  # Redirect path after the onboarding process is completed.
  def after_onboarding_path(user)
    after_sign_in_path_for(user)
  end

  # Setup the base breadcrumbs for the application.
  def setup_base_breadcrumbs
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, (user_signed_in? ? dashboard_path : root_path)
    add_breadcrumb current_account.name, dashboard_path if current_account.present?
  end
end
