module Kiqr
  module Translations
    class Engine < ::Rails::Engine
      initializer "kiqr.translations.setup_locale" do
        I18n.default_locale = Kiqr::Config.default_locale
        I18n.available_locales = Kiqr::Config.available_locales

        # Include helpers to the applications controllers and views.
        Kiqr.include_helpers(Kiqr::Translations::Controllers)
      end
    end
  end
end
