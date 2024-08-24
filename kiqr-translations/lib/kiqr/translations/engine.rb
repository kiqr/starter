module Kiqr
  module Translations
    class Engine < ::Rails::Engine
      initializer "kiqr.translations.setup_locale" do
        # Include helpers to the applications controllers and views.
        Kiqr.include_helpers(Kiqr::Translations::Controllers)
      end
    end
  end
end
