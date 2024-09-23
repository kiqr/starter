module Kiqr
  class Engine < ::Rails::Engine
    engine_name "kiqr"

    # Include helpers to the applications controllers and views.
    initializer "kiqr.controller_and_view_helpers" do
      Kiqr.include_helpers(Kiqr::Controllers)
      Kiqr.include_helpers(Kiqr::Translations)
    end

    initializer "kiqr.model_helpers" do
      ActiveSupport.on_load(:active_record) do
        extend Kiqr::Models
      end
    end
  end
end
