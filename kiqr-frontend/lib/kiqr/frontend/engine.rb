module Kiqr
  module Frontend
    class Engine < ::Rails::Engine
      initializer "kiqr.frontend.helpers" do
        # Include helpers to the applications controllers and views.
        Kiqr.include_helpers(Kiqr::Frontend)
        Kiqr.include_helpers(Kiqr::Frontend::Controllers)
      end
    end
  end
end
