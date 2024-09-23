class ApplicationController < ActionController::Base
  # Turn on request forgery protection. Bear in mind that GET and HEAD requests are not checked.
  protect_from_forgery with: :exception, prepend: true

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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

  protected

  def setup_base_breadcrumbs
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, (user_signed_in? ? dashboard_path : root_path)
    add_breadcrumb current_account.name, dashboard_path if current_account.present?
  end
end
