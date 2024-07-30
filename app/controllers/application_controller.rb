class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Add more types of flash message to match the available variants of Irelia::Notification::Component.
  add_flash_types :success, :warning

  # Include KIQR core functionality [https://github.com/kiqr/kiqr]
  include Kiqr::Framework
end
