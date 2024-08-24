module Kiqr
  module Views
    module FormHelpers
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
  end
end
