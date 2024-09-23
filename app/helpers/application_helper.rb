module ApplicationHelper
  # Generate a QR code for the given text.
  # This is used to generate a QR code for the user's two factor authentication app.
  def render_qr_code(content)
    RQRCode::QRCode.new(content).as_svg(
      module_size: 4
    ).html_safe
  end
  
  # Get the options for the locale form select field
  def options_for_locale
    I18n.available_locales.map do |locale|
      [ I18n.t("kiqr.translations.locales.#{locale}"), locale ]
    end
  end
  
  # Get the options for time zone form select field
  def options_for_time_zone
    ActiveSupport::TimeZone.all.map do |time_zone|
      [ time_zone.to_s, time_zone.name ]
    end
  end
end
