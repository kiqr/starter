class ApplicationController < ActionController::Base
  include Kiqr::Authentication
  include Kiqr::FlashMessages
  include Kiqr::Locales
  include Kiqr::Submenu
  include Kiqr::UrlHelper

  # Turn on request forgery protection. Bear in mind that GET and HEAD requests are not checked.
  protect_from_forgery with: :exception, prepend: true

  # Ensure that a user is signed in and has completed the onboarding process before accessing any other page.
  # This is done in the ApplicationController to ensure that all controllers inherit this behavior.
  # To skip this behavior in a controller, use:
  #   skip_before_action :authenticate_user!
  #   skip_before_action :ensure_onboarded
  before_action :authenticate_user!
  before_action :ensure_onboarded

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Add more types of flash message to match the available variants in Irelia::Notification::Component.
  add_flash_types :success, :warning

  # Configure the base breadcrumbs for all pages to "Dashboard > (Account Name)"
  before_action do
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, (user_signed_in? ? dashboard_path : root_path)
    add_breadcrumb current_account.name, dashboard_path if current_account.present?
  end

  # Automatically include account_id in all URL options if it is already present in the params.
  # This is used to ensure that all routes are scoped to the current team. Personal account
  # routes are not affected.
  def default_url_options
    { account_id: params[:account_id] }
  end
end
