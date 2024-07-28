class KiqrController < ApplicationController
  before_action :setup_root_breadcrumbs

  private

  # Add the dashboard breadcrumb
  def setup_root_breadcrumbs
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, dashboard_path
    add_breadcrumb current_account.name, dashboard_path if current_account.present?
  end

  # Get the options for the locale form select field
  def options_for_locale
    I18n.available_locales.map do |locale|
      [ I18n.t("kiqr.languages.#{locale}"), locale ]
    end
  end
  helper_method :options_for_locale

  # Get the options for time zone form select field
  def options_for_time_zone
    ActiveSupport::TimeZone.all.map do |time_zone|
      [ time_zone.to_s, time_zone.name ]
    end
  end
  helper_method :options_for_time_zone
end
