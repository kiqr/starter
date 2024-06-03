module Kiqr
  module FormHelper
    # Get the options for the locale form select field
    def options_for_locale
      I18n.available_locales.map do |locale|
        [I18n.t("languages.#{locale}"), locale]
      end
    end
  end
end
