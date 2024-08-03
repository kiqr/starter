module Kiqr
  module Locales
    extend ActiveSupport::Concern

    included do
      before_action :setup_locales
    end

    private

    # The locale is set to the user's locale if present, otherwise it is set to the default locale
    # Get available locales and default_locale from Kiqr::Config
    def setup_locales
      I18n.default_locale = Kiqr::Config.default_locale
      I18n.available_locales = Kiqr::Config.available_locales
      I18n.locale = current_user&.locale&.to_sym || I18n.default_locale
    end
  end
end
