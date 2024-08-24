module Kiqr
  module Translations
    class Engine < ::Rails::Engine
      initializer "kiqr.translations.helpers" do
        # Include helpers to the applications controllers and views.
        Kiqr.include_helpers(Kiqr::Translations::Controllers)
      end
    end
  end
end
