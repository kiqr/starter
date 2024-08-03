class ApplicationController < ActionController::Base
  include Kiqr::SetCurrentAttributes
  include Kiqr::AccountHelper
  include Kiqr::RendersSubmenu
  include Kiqr::UrlHelper
  include Kiqr::FlashMessages
  include Kiqr::Locales

  # => Controller hooks
  before_action :authenticate_user!
  before_action :ensure_onboarded

  # => Rails configurations
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action do
    # Add the home icon to the breadcrumb
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, (user_signed_in? ? dashboard_path : root_path)
  end

  # Automatically include account_id in all URL options if it is already present in the params.
  # This is used to ensure that all routes are scoped to the current team. Personal account
  # routes are not affected.
  def default_url_options
    { account_id: params[:account_id] }
  end
end
