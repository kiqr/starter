module Kiqr
  class Engine < ::Rails::Engine
    engine_name "kiqr"

    initializer "kiqr.model_helpers" do
      ActiveSupport.on_load(:active_record) do
        extend Kiqr::Models
      end
    end
  end
end
