class KiqrController < ApplicationController
  before_action :setup_dashboard_breadcrumb

  private

  # Add the dashboard breadcrumb
  def setup_dashboard_breadcrumb
    add_breadcrumb helpers.irelia_icon { "fa fa-home" }, dashboard_path
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
