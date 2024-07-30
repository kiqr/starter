class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Add more types of flash message to match the available variants of Irelia::Notification::Component.
  add_flash_types :success, :warning

  # Include KIQR core functionality [https://github.com/kiqr/kiqr]
  include Kiqr::Framework

  # => Controller hooks
  # Register the root breadcrumbs
  before_action :add_root_basecrumbs

  private

  # Add the dashboard breadcrumb
  def add_root_basecrumbs
    return unless user_signed_in?

    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, dashboard_path
  end
end
